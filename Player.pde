/** Clase que representa al jugador */
class Player extends GameObject implements IMovable{
  /** Representa la velocidad del jugador */
  private float speed;
  /** Representa la maxima velocidad del jugador */
  private float topSpeed;
  /** Representa la direccion de movimiento del jugador */
  private Vector direccion;

  /* -- CONSTRUCTORES -- */
  /** Constructor por defecto */
  public Player() {
  }
  /** Constructor parametrizado */
  public Player(PVector posicion) {
    this.posicion = posicion;
    this.ancho = 50;
    this.speed = 0;
    this.topSpeed = 250;
    this.direccion = new Vector(this.posicion, "down");
  }

  /* -- METODOS -- */
  /** Metodo que dibuja al jugador en pantalla */
  public void display() {
    fill(200, 30);
    circle(this.posicion.x, this.posicion.y, ancho);
    textSize(20);
    fill(255);
  }
  
  public void mover() {
    float deltaTime = 1.0/frameRate;
    float acceleration = 60;
    float deceleration = 10;

    // operador ternario para acelerar o desacelerar segun si se apreta una tecla
    this.speed = W_PRESSED || D_PRESSED || S_PRESSED || A_PRESSED ? this.speed+acceleration : this.speed-deceleration;

    //  Verificar si se están presionando las teclas 'w', 'a', 's' o 'd'
    if (W_PRESSED) {
      this.direccion = this.direccion.sumar(new Vector(this.posicion, "up"));
    }
    if (S_PRESSED) {
      this.direccion = this.direccion.sumar(new Vector(this.posicion, "down"));
    }
    if (A_PRESSED) {
      this.direccion = this.direccion.sumar(new Vector(this.posicion, "left"));
    }
    if (D_PRESSED) {
      this.direccion = this.direccion.sumar(new Vector(this.posicion, "right"));
    }
    this.direccion.display();
    
    if (this.direccion.obtenerMagnitud() != 0) {
      this.direccion.getDestino().normalize(); // Normalizar la dirección para que el movimiento diagonal no sea mas rapido
    }
    // Limitar la velocidad
    this.speed = constrain(speed, 0, topSpeed);

    // Actualizar la posicion del jugador
    this.posicion.add(this.direccion.getDestino().copy().mult(this.speed * deltaTime));

    text("Aceleracion: "+acceleration, 30, 40);
    text("Velocidad: "+this.speed, 30, 80);
    text("Direccion destino:"+this.direccion.destino, 30, 120);
  }// end mover
  
  /* -- ASESORES -- */
  /* Getters */
  /** Devuelve la velocidad maxima del jugador */
  public float getTopSpeed(){
    return this.topSpeed;
  }
  /** Devuelve la velocidad del jugador */
  public float getSpeed(){
    return this.speed;
  }
  /** Devuelve la direccion del jugador */
  public Vector getDireccion(){
    return this.direccion;
  }
  
  /* Setters */
  /** Asigna una nueva velocidad maxima al jugador */
  public void setTopSpeed( float topSpeed){
    this.topSpeed = topSpeed;
  }
}
