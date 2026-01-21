/** Clase que representa al jugador */
class Player extends GameObject implements IVisualizable, EffectTarget {
  /** Representa la velocidad y maxima velocidad del jugador */
  private float speed,  topSpeed;
  /** Representa la direccion de movimiento del jugador */
  private Vector direccion;
  /** Representa la posicion del jugador con respecto a la dungeon*/
  private int col, row;
  
  /** Controla si el jugador está disparando o no */
  private boolean isShooting;
  /** Representa el ultimo disparo */
  private long lastShotTime = 0;       
  /** Representa el tiempo minimo entre cada disparo */
  private int shootCooldown = 310;
  
  private float damage;
  
  /** Representa el sprite del jugador */
  private SpriteObject sprite;
  /** Representa el estado de la animación del sprite del jugador */
  private int animationState;
  private Colisionador collider;
  private Direction lastDirection = Direction.RIGHT;
  
  private EffectManager effectManager;

  
  private int lives;
  private int maxLives;
  private boolean isHit; // bandera para el impacto
  private int hitTime; // tiempo del impacto
  private int hitDuration = 500; // duración del impacto en milisegundos

  /* -- CONSTRUCTORES -- */
  /** Constructor parametrizado */
  public Player(PVector posicion, PVector startPos) {
    this.posicion = posicion;
    this.alto = 20;
    this.ancho = 20;
    this.speed = 0;
    this.topSpeed = 250*difficulty.playerSpeed;
    this.damage = 1;
    this.sprite = new SpriteObject("mage.png", ancho, alto, 4);
    this.animationState = MaquinaEstadosAnimacion.ESTATICO_DERECHA;
    this.direccion = new Vector(posicion, Direction.DOWN); // Vector inicial hacia abajo
    this.collider = new Colisionador(this.posicion,this.ancho*3);
    this.lives = difficulty.playerLives;
    this.maxLives = lives;
    this.isHit = false;
    this.hitTime = 0;
    
    // Inicializar posición en la dungeon para no crashear
    this.col = int(startPos.x);
    this.row = int(startPos.y);
    
    effectManager = new EffectManager(this);
  }

  /* -- METODOS -- */
  /** Metodo que dibuja al jugador en pantalla */
  public void display() {
    if (isHit && millis() - hitTime >= hitDuration) {
      isHit = false;
    }

     if (isHit) {
      tint(255, 0, 0); // el jugador se torna rojo cuando está en estado de impacto
    } else {
      tint(255);
    }
    stroke(0);
    fill(200, 30);
    this.sprite.render(this.animationState, this.posicion.copy());
    textSize(20);
    fill(255);
    dibujarBarraVida(50, 5, 35);
    text("vidas: " + lives, 100, 100);
    text("vel: " + speed, 100, 150);

    //collider.display(255);
  }

  /** Metodo que mueve al jugador */
  public void mover(InputManager input) {
    this.direccion.setOrigen(this.posicion.copy());

    float acceleration = 60*difficulty.playerSpeed;
    float deceleration = 20;

    // Operador ternario para acelerar o desacelerar segun si se apreta una tecla
    speed = input.isMoving() ? speed + acceleration : speed - deceleration;

    
    // Sumar todas las direcciones activas como vectores
    for (Direction dir : input.getActiveDirections()) {
      direccion = direccion.sumar(new Vector(posicion, dir));
    }
    
    // Normalizar para diagonales
    if (direccion.obtenerMagnitud() != 0) {
      this.direccion.normalizar(); // Normalizar la dirección para que el movimiento diagonal no sea mas rapido
    }
    
    // Limitar la velocidad
    this.speed = constrain(this.speed, 0, this.topSpeed);

    // Actualizar la posicion del jugador
    this.posicion.add(direccion.getDestino().copy().mult(speed * Time.getDeltaTime(frameRate)));

    // Limitar el movimiento dentro de la pantalla
    posicion.x = constrain(posicion.x, ancho * 2 + 40, width - ancho * 2 - 40);
    posicion.y = constrain(posicion.y, alto * 2 + 40, height - alto * 2- 40);
    
    //Actualizando la posición del collider
    collider.setPosicion(posicion);
    
  }// end mover
  
  public void updateAnimation(InputManager input) {
    // Movimiento
    if (input.isMoving()) {
        // Tomar la última direccion activa
        for (Direction dir : input.getActiveDirections()) {
            lastDirection = dir; // actualizar  direccion
        }

        switch (lastDirection) {
            case RIGHT: animationState = MaquinaEstadosAnimacion.MOV_DERECHA; break;
            case LEFT:  animationState = MaquinaEstadosAnimacion.MOV_IZQUIERDA; break;
            case UP:    animationState = MaquinaEstadosAnimacion.MOV_DERECHA; break; 
            case DOWN:  animationState = MaquinaEstadosAnimacion.MOV_IZQUIERDA; break; 
        }
    } else {
        // Idle segun direccion
        switch (lastDirection) {
            case RIGHT: animationState = MaquinaEstadosAnimacion.ESTATICO_DERECHA; break;
            case LEFT:  animationState = MaquinaEstadosAnimacion.ESTATICO_IZQUIERDA; break;
            case UP:    animationState = MaquinaEstadosAnimacion.ESTATICO_DERECHA; break; 
            case DOWN:  animationState = MaquinaEstadosAnimacion.ESTATICO_IZQUIERDA; break; 
        }
    }

    // Disparo
    if (input.isShooting()) {
        Direction shootDir = input.getShootDirection();
        if (shootDir != null) {
            lastDirection = shootDir; // actualizar hacia donde disparo
        }

        switch (lastDirection) {
            case RIGHT: animationState = MaquinaEstadosAnimacion.ATAQUE_DERECHA; break;
            case LEFT:  animationState = MaquinaEstadosAnimacion.ATAQUE_IZQUIERDA; break;
            case UP:    animationState = MaquinaEstadosAnimacion.ATAQUE_DERECHA; break; 
            case DOWN:  animationState = MaquinaEstadosAnimacion.ATAQUE_IZQUIERDA; break; 
        }
    }
  }

  
  public Door checkCollision(Room roomActual) {
    if (!roomActual.hasDoors()) return null;
  
    for (Door door : roomActual.getAllDoors()) {
      if (door != null && door.collider.colisionaCon(this.collider) && door.getIsOpen()) {
        return door; // devuelve el evento
      }
    }
    return null;
  }

  /** Actualiza la posicion del jugador segun los parametros anteriores */
  private void updatePosition(int newCol, int newRow, PVector newPos) {
    this.col = newCol;
    this.row = newRow;
    this.posicion = newPos.copy();
  }

  /** Devuelve una bala a una dirección definida por una tecla para ser gestionada posteriormente por un GestorBullets */
  public void shoot(GestorBullets gestor, InputManager input, BulletFactory factory) {
    if (input.isShooting() && input.getShootDirection() != null) {
      long now = millis();
      if (now - lastShotTime >= shootCooldown) {
        // Usar la fábrica para crear la bala del jugador
        Bullet b = factory.createPlayerBullet(this.posicion.copy(), input.getShootDirection(), this.damage);
        gestor.addBullet(b);
        lastShotTime = now;
      }
    }
  }
  
  public void dibujarBarraVida(float barraAncho, float barraAlto, float offsetY) {
    float porcentaje = (float) lives / maxLives;   // proporción de vida
    float anchoActual = porcentaje * barraAncho;   // ancho proporcional

    // Interpolación lineal del color de verde (vida completa) a rojo (sin vida)
    float r = map(lives, 0, maxLives, 255, 0);
    float g = map(lives, 0, maxLives, 0, 255);
    fill(r, g, 0);

    rect(posicion.x - barraAncho / 2, posicion.y - offsetY, anchoActual, barraAlto);

    noFill();
    stroke(0);
    rect(posicion.x - barraAncho / 2, posicion.y - offsetY, barraAncho, barraAlto);
  }

  
  public void receiveDamage() {
    if (isHit) return;
  
    lives --;
    lives = max(0, lives);
  
    isHit = true; // establecer bandera de impacto
    hitTime = millis(); // iniciar temporizador
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
    
  /** Devuelve el estado de la animación del jugador */
  public int getAnimationState() {  return this.animationState;  }
  
  public int getLives() {  return lives;  }
  public Colisionador getCollider() { return collider; }
  
  public boolean getIsHit(){
    return this.isHit;
  }
  
  public EffectManager getEffectManager() { return effectManager; }
  
  public PVector getCurrentPos(){ return new PVector(this.col, this.row); }
  public float getDamage() {  return this.damage; }

    /* Setters */
  /** Asigna una nueva velocidad maxima al jugador */
  public void setTopSpeed( float topSpeed) {  this.topSpeed = topSpeed;  } 
  
  /** Actualiza si el jugador está disparando o no */
  public void setIsShooting(boolean isShooting) {  this.isShooting = isShooting;  }
    
  /** Actualiza el estado de la animación del jugador */
  public void setAnimationState(int animationState) {  this.animationState = animationState;  }
  
  public void setLives(int lives) {  this.lives = lives;  }
  
  public void setDamage(float damage) {  this.damage = damage;  }

}
