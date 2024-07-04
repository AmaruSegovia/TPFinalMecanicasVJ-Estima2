class Enemy extends GameObject {
  protected int lives;

  public Enemy(PVector posicion, int vidas) {
    super(posicion, 40, 40); // constructor de clase GameObject con la pos y tamaño
    this.lives = vidas;
  }

  public int getLives() {
    return lives;
  }

  public void setLives(int lives) {
    this.lives = lives;
  }

  public void reducirVida() {
     println("Vida antes de ser impactado: " + this.lives);
    this.lives--;
    println("Vida después de ser impactado: " + this.lives);
  }
}
