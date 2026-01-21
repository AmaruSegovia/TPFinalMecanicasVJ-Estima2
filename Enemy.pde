/* Clase que representa a los enemigos por defecto */
public abstract class Enemy extends GameObject implements IDaniable{
  protected int lives;
  protected int maxLives;
  
  protected boolean isHit; // bandera para el impacto
  protected int hitTime; // tiempo del impacto
  protected int hitDuration = 500; // duración del impacto en milisegundos
  
  protected color originalColor;
  protected color currentColor;
  
  protected Colisionador collider;
  protected SpriteObject sprite;
  protected float damage;
  protected LifeBar lifeBar;
  /* -- CONSTRUCTOR -- */
  public Enemy(PVector posicion, int vidas, color colorInicial, float damage) {
    this.posicion = posicion; // constructor de clase GameObject con la pos y tamaño
    this.lives = vidas;
    this.maxLives = vidas;

    this.damage = damage;
    this.isHit = false;
    this.hitTime = 0;
    this.originalColor = colorInicial;
    this.currentColor = colorInicial;
    
    this.collider = new Colisionador(this.posicion, this.ancho - 10);
    this.lifeBar = new LifeBar(30, 4, 20);
  }

  @Override
  public void receiveDamage(float amount) {
    lives -= amount;
    lives = max(0, lives);
  }
  
   public void checkCollisionWithPlayer(Player player) {
    if (  collider.colisionaCon(player.collider) && !player.isHit) {
      player.receiveDamage();
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
  
  public int getMaxLives() {
    return this.maxLives;
  }
  
  public boolean isDead() { return lives <= 0; }

  public void setLives(int lives) {
    this.lives = lives;
  }
  
  public Colisionador getCollider() { return collider; }
  
  
  protected abstract void display();
  public abstract void update(Player player, GestorEnemigos enemies);
}
