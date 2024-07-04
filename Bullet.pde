/** Clase que define las balas del jugador */
private class Bullet extends GameObject implements IMovable, IVisualizable {

  /* -- ATRIBUTOS -- */
  /** Representa la velocidad de la bala */
  private float speed;
  /** Representa la dirección de la bala */
  private PVector direction;
  /** Representa el sprite de la bala */
  private SpriteObject sprite;
 private Colisionador colisionador;
  /* -- CONSTRUCTORES -- */
  /** Constructor parametrizado */
  public Bullet(PVector pos, int ancho, int alto, PVector direction, float speed) {
    super(pos, ancho, alto);
    this.direction = direction;
    this.speed = speed;
    this.sprite = new SpriteObject("playerBullet.png", ancho, alto);
    this.colisionador = new Colisionador(); 
  }

  /* -- ACCESORES (GETTERS Y SETTERS) -- */
  /* Getters */
  /* Devuelve la velocidad de la bala */
  public float getSpeed() {
    return this.speed;
  }

  /* Devuelve la dirección de la bala */
  public PVector getDirection() {
    return this.direction;
  }

  /* Setters */
  /* Cambia la velocidad de la bala */
  public void setSpeed() {
    this.speed = speed;
  }

  /* Cambia la dirección de la bala */
  public void setDirection() {
    this.direction = direction;
  }

  /* -- MÉTODOS -- */
  /** Método para mover las balas (implementando la interfaz IMovable) */
  public void mover() {
    this.posicion.add(this.direction.copy().mult(this.speed).copy().mult(Time.getDeltaTime(frameRate)));
  }

  /** Método para dibujar las balas (implementando la interfaz IVisualizable) */
  public void display() {    
    this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(this.posicion.x, this.posicion.y));
    /*
    stroke(#149eee);
    fill(3 * sin(this.posicion.x + this.posicion.y) * 100, 255, 255);
    circle(this.posicion.x, this.posicion.y, this.ancho);
    */
  }
  
   public boolean verificarColision(Enemy enemigo) {
    if (colisionador.colisionarCirculo(this, enemigo)) {
      enemigo.reducirVida();
      return true;
    }
    return false;
  }
}
