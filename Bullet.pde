/** Clase que representa las balas del jugador */
private class Bullet extends GameObject implements IMovable, IVisualizable {
  /* -- ATRIBUTOS -- */
  /** Representa la velocidad de la bala */
  private float speed;
  /** Representa la dirección de la bala */
  private PVector direction;
  /** Representa el sprite de la bala */
  private SpriteObject sprite;
  /** Representa el area de colision de la bala */
  private Colisionador colisionador;
  private String pertenece;

  // var para orbitar 
  float angulo;
  boolean disparada;
  
  /* -- CONSTRUCTORES -- */
  /** Constructor parametrizado */
  public Bullet(PVector pos, int ancho, int alto, PVector direction, float speed, String pertenece) {
    super(pos, ancho, alto);
    this.pertenece = pertenece; 
    this.direction = direction;
    this.speed = speed;
    this.sprite = new SpriteObject("playerBullet.png", ancho, alto);
    this.colisionador = new Colisionador(this.posicion, ancho, alto); 
    this.disparada = true;
  }
  /** Constructor para balas con angulo para el enemigo */
  public Bullet(PVector pos, float angulo){
    this.posicion = pos;
    this.ancho = 10;
    this.angulo = angulo;
    this.speed = 150;
    this.disparada = true;
    this.colisionador = new Colisionador(this.posicion, ancho, alto); 
  }
  
  /** Constructor para balas que orbitan para el enemigo */
  Bullet(PVector posicion, float angulo, float radioOrbita) {
    this.posicion = posicion.copy().add(PVector.fromAngle(angulo).mult(radioOrbita));
    this.angulo = angulo;
    this.speed = 300;
    this.ancho = 10;
    this.disparada = false;
    this.colisionador = new Colisionador(this.posicion, ancho, alto); 
  }

  /* -- MÉTODOS -- */
  /** Método para mover las balas (implementando la interfaz IMovable) */
  public void mover() {
    if (this.direction != null){
      this.posicion.add(this.direction.copy().mult(this.speed).copy().mult(Time.getDeltaTime(frameRate)));
    }
  }

  /** Método para dibujar las balas (implementando la interfaz IVisualizable) */
  public void display() {
    if(this.pertenece == "jugador"){
      this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(this.posicion.x, this.posicion.y));
    }
    circle(this.posicion.x, this.posicion.y,this.ancho);
  }
  
  void disparar() {
    disparada = true;
    this.direction = PVector.fromAngle(angulo);
  }
  void orbitar(PVector bossPosition) {
    if (!disparada) {
      this.angulo += 0.03; // Velocidad de la órbita
      posicion = bossPosition.copy().add(PVector.fromAngle(angulo).mult(100));
    }
  }
  
  public void moverAng() {
      this.posicion.add(PVector.fromAngle(angulo).mult(speed).mult(Time.getDeltaTime(frameRate)));
  }
  /** Verifica la colision del colisionador con los enemigos */
   public boolean verificarColision(Enemy enemigo) {
    if (colisionador.isCircle(enemigo.collider)) {
      enemigo.reducirVida();
      return true;
    }
    return false;
  }

  /* -- ACCESORES (GETTERS Y SETTERS) -- */
  /* Getters */
  /** Devuelve la velocidad de la bala */
  public float getSpeed() {  return this.speed;  }

  /** Devuelve la dirección de la bala */
  public PVector getDirection() {  return this.direction;  }

  /* Setters */
  /** Cambia la velocidad de la bala */
  public void setSpeed() {  this.speed = speed;  }

  /** Cambia la dirección de la bala */
  public void setDirection() {  this.direction = direction;  }
}
