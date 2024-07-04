class Enemy extends GameObject {
  protected int lives;
  protected boolean isHit; // bandera para el impacto
  protected int hitTime; // tiempo del impacto
  protected int hitDuration = 1000; // duración del impacto en milisegundos
  protected color originalColor;
  protected color currentColor;
  
  public Enemy(PVector posicion, int vidas, color colorInicial) {
    super(posicion, 40, 40); // constructor de clase GameObject con la pos y tamaño
    this.lives = vidas;
    this.isHit = false;
    this.hitTime = 0;
    this.originalColor = colorInicial;
    this.currentColor = colorInicial;
  }

  public int getLives() {
    return lives;
  }

  public void setLives(int lives) {
    this.lives = lives;
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
  
}
