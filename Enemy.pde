/* Clase que representa a los enemigos por defecto */
public abstract class Enemy extends GameObject {
  protected int lives;
  protected boolean isHit; // bandera para el impacto
  protected int hitTime; // tiempo del impacto
  protected int hitDuration = 500; // duración del impacto en milisegundos
  protected color originalColor;
  protected color currentColor;
  protected Colisionador collider;
  protected SpriteObject sprite;
  protected float damage;
  /* -- CONSTRUCTOR -- */
  public Enemy(PVector posicion, int vidas, color colorInicial, float damage) {
    this.posicion = posicion; // constructor de clase GameObject con la pos y tamaño
    this.lives = vidas;
    this.damage = damage;
    this.isHit = false;
    this.hitTime = 0;
    this.originalColor = colorInicial;
    this.currentColor = colorInicial;
    this.collider = new Colisionador(this.posicion, this.ancho-10);
  }

  public void reducirVida() {   
    this.lives--;
    this.isHit = true; // establecer bandera de impacto
    this.hitTime = millis(); // iniciar temporizador
  }
  
   public void dibujarBarraVida(float vidasMaximas, float barraAncho, float barraAlto, float offsetY) {
    float anchoActual = (lives / vidasMaximas) * barraAncho; // ancho actual basado en las vidas

    // Interpolación lineal del color de verde (0, 255, 0) a rojo (255, 0, 0)
    float r = map(lives, 0, vidasMaximas, 255, 0);
    float g = map(lives, 0, vidasMaximas, 0, 255);
    fill(r, g, 0); // color interpolado para la barra de vida

    rect(posicion.x - barraAncho / 2, posicion.y - offsetY, anchoActual, barraAlto); // posición de la barra encima del enemigo

    // Dibujar el contorno de la barra de vida
    noFill();
    stroke(0);
    rect(posicion.x - barraAncho / 2, posicion.y - offsetY, barraAncho, barraAlto);
  }
  
   public void checkCollisionWithPlayer(Player player) {
    if (  collider.colisionaCon(player.collider) && !player.isHit) {
      player.reducirVida();
    }
  }
  
  public void limitarDentroPantalla(int borde) {
    this.posicion.x = constrain(this.posicion.x, borde, width - borde);
    this.posicion.y = constrain(this.posicion.y, borde, height - borde);
  }
  
  public void updateHitEffect() {
    if (isHit) {
      float elapsed = millis() - hitTime;
      if (elapsed < hitDuration) {
        float lerpFactor = elapsed / (float)hitDuration;
        currentColor = lerpColor(color(255, 0, 0), originalColor, lerpFactor);
      } else {
        isHit = false;
        currentColor = originalColor;
      }
    }
  }
  
  /* -- ASESOERS -- */
  public int getLives() {
    return lives;
  }
  
  public boolean isDead() { return lives <= 0; }

  public void setLives(int lives) {
    this.lives = lives;
  }
  
  public Colisionador getCollider() { return collider; }
  
  
  public abstract void update(Player player, GestorEnemigos enemies);
  public abstract void display();
}
