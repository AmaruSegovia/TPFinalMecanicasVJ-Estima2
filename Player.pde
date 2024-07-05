/** Clase que representa al jugador */
class Player extends GameObject implements IMovable, IVisualizable {
  /** Representa la velocidad y maxima velocidad del jugador */
  private float speed,  topSpeed;
  /** Representa la direccion de movimiento del jugador */
  private Vector direccion;
  /** Representa la posicion del jugador con respecto a la dungeon*/
  private int col, row;
  /** Controla si el jugador está disparando o no */
  private boolean isShooting;
  /** Representa el tiempo transcurrido tras el último disparo */
  private float timeSinceLastShot;
  /** Representa el sprite del jugador */
  private SpriteObject sprite;
  /** Representa el estado de la animación del sprite del jugador */
  private int animationState;
  private Colisionador collider;
  
  private int lives;
  private boolean isHit; // bandera para el impacto
  private int hitTime; // tiempo del impacto
  private int hitDuration = 500; // duración del impacto en milisegundos

  /* -- CONSTRUCTORES -- */
  /** Constructor parametrizado */
  public Player(PVector posicion) {
    this.posicion = posicion;
    this.alto = 20;
    this.ancho = 20;
    this.speed = 0;
    this.topSpeed = 250;
    this.sprite = new SpriteObject("mage.png", ancho, alto, 4);
    this.animationState = MaquinaEstadosAnimacion.ESTATICO_DERECHA;
    this.direccion = new Vector("down");
    this.collider = new Colisionador(this.posicion,this.ancho*3);
    this.lives = 12;
    this.isHit = false;
    this.hitTime = 0;
  }

  /* -- METODOS -- */
  /** Metodo que dibuja al jugador en pantalla */
  public void display() {
     if (isHit && millis() - hitTime < hitDuration) {
      tint(255, 0, 0); // el jugador se torna rojo cuando está en estado de impacto
    } else {
      tint(255);
      isHit = false; // restablecer la bandera
    }
    stroke(0);
    fill(200, 30);
    this.sprite.render(this.animationState, new PVector(this.posicion.x, this.posicion.y));
    textSize(20);
    fill(255);
    dibujarBarraVida(12,50, 5, 35);
  }

  /** Metodo que mueve al jugador */
  public void mover() {
    this.direccion.setOrigen(this.posicion);

    float acceleration = 60;
    float deceleration = 10;

    // Operador ternario para acelerar o desacelerar segun si se apreta una tecla
    this.speed = W_PRESSED || D_PRESSED || S_PRESSED || A_PRESSED ? this.speed+acceleration : this.speed-deceleration;

    //  Verificar si se están presionando las teclas 'w', 'a', 's' o 'd'
    if (W_PRESSED)  this.direccion = this.direccion.sumar(new Vector("up"));
    if (S_PRESSED)  this.direccion = this.direccion.sumar(new Vector("down"));
    if (A_PRESSED)  this.direccion = this.direccion.sumar(new Vector("left"));
    if (D_PRESSED)  this.direccion = this.direccion.sumar(new Vector("right"));

    if (this.direccion.obtenerMagnitud() != 0) {
      this.direccion.getDestino().normalize(); // Normalizar la dirección para que el movimiento diagonal no sea mas rapido
    }
    // Limitar la velocidad
    this.speed = constrain(this.speed, 0, this.topSpeed);

    // Actualizar la posicion del jugador
    this.posicion.add(this.direccion.getDestino().copy().mult(this.speed * Time.getDeltaTime(frameRate)));

    // Limitar el movimiento del jugador
    this.posicion.x = constrain(this.posicion.x, 0 + this.ancho*2, width - this.ancho*2);
    this.posicion.y = constrain(this.posicion.y, 0 + this.ancho*2, height - this.ancho*2);
    
    //Actualizando la posición del collider
    this.collider.setPosicion(this.posicion);
    
  }// end mover


  public void checkCollisions(Room roomActual) {
    // Si en la habitacion actual no hay puertas salir
    if (roomActual.hasDoors() == false) return;

    for (Door door : roomActual.doorList) {
      //Si colisiono con una puerta preparar nuevas posiciones
      if (door != null && door.collider.isCircle(this.collider) && door.getIsOpen()) {
        int newCol = this.col, newRow = this.row;
        PVector newPos = new PVector(0, 0);
        Door newDoor;
        switch (door.direction) {
        case "UP":
          newRow = row - 1;
          newDoor= new Door("DOWN");
          newPos = new PVector(newDoor.getPosicion().x, newDoor.getPosicion().y - newDoor.getAncho() * 1.05);
          break;
        case "DOWN":
          newRow = row + 1;
          newDoor = new Door("UP");
          newPos = new PVector(newDoor.getPosicion().x, newDoor.getPosicion().y + newDoor.getAncho() * 1.05);
          break;
        case "LEFT":
          newCol = col - 1;
          newDoor = new Door("RIGHT");
          newPos = new PVector(newDoor.getPosicion().x - newDoor.getAncho() * 1.05, newDoor.getPosicion().y );
          break;
        case "RIGHT":
          newCol = col + 1;
          newDoor = new Door("LEFT");
          newPos = new PVector(newDoor.getPosicion().x + newDoor.getAncho()*1.05, newDoor.getPosicion().y );
          break;
        }
        //si la proxima habitacion esta en el rango de la matriz actualizar posiciones
        Room nextRoom = dungeon.getRoom(newCol, newRow);
        if (nextRoom != null) {
          updatePosition(newCol, newRow, newPos);
        }
      }
    }
  }
  /** Actualiza la posicion del jugador segun los parametros anteriores */
  private void updatePosition(int newCol, int newRow, PVector newPos) {
    this.col = newCol;
    this.row = newRow;
    this.posicion = newPos;
  }

  /** Devuelve una bala a una dirección definida por una tecla para ser gestionada posteriormente por un GestorBullets */
  public Bullet shoot(char input) {
    if (input == 'i') return new Bullet(this.posicion.copy(), 10, 10, new PVector(0, -1), 400,"jugador");
    if (input == 'j') return new Bullet(this.posicion.copy(), 10, 10, new PVector(-1, 0), 400,"jugador");
    if (input == 'k') return new Bullet(this.posicion.copy(), 10, 10, new PVector(0, 1), 400,"jugador");
    if (input == 'l') return new Bullet(this.posicion.copy(), 10, 10, new PVector(1, 0), 400,"jugador");
    return null;
  }
  
  public boolean verificarColision(Enemy enemigo, Bala bala) {
    if ((collider.isCircle(enemigo.collider) || collider.isCircle(bala.collider)) && !isHit) {
      enemigo.reducirVida();
      return true;
    }
    return false;
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
  
  public void reducirVida() {
    this.lives--;
    this.isHit = true; // establecer bandera de impacto
    this.hitTime = millis(); // iniciar temporizador
  }

   /* Getters */
  /** Devuelve la velocidad maxima del jugador */
  public float getTopSpeed() {  return this.topSpeed;  }
  
  /** Devuelve la velocidad del jugador */
  public float getSpeed() {  return this.speed;  }
  
  /** Devuelve la direccion del jugador */
  public Vector getDireccion() {  return this.direccion;  }  
  
  /** Devuelve la columna en la que se encuentra el jugador */
  public int getCol(){  return this.col;  }  
  
  /** Devuelve la fila en la que se encuentra el jugador */
  public int getRow(){  return this.row;  }
  
  /** Devuelve si el jugador está disparando o no */
  public boolean getIsShooting() {  return this.isShooting;  }
  
  /** Devuelve si el jugador está disparando o no */
  public float getTimeSinceLastShot() {  return this.timeSinceLastShot;  }
  
  /** Devuelve el estado de la animación del jugador */
  public int getAnimationState() {  return this.animationState;  }
  
  public int getLives() {  return lives;  }

    /* Setters */
  /** Asigna una nueva velocidad maxima al jugador */
  public void setTopSpeed( float topSpeed) {  this.topSpeed = topSpeed;  } 
  
  /** Actualiza si el jugador está disparando o no */
  public void setIsShooting(boolean isShooting) {  this.isShooting = isShooting;  }
  
  /** Actualiza si el jugador está disparando o no */
  public void setTimeSinceLastShot(float timeSinceLastShot) {  this.timeSinceLastShot = timeSinceLastShot;  }
  
  /** Actualiza el estado de la animación del jugador */
  public void setAnimationState(int animationState) {  this.animationState = animationState;  }
  
  public void setLives(int lives) {  this.lives = lives;  }

}
