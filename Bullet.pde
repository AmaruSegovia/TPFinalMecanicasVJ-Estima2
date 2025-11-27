/** Enum para identificar el duenioo de la bala */
enum BulletOwner {
  PLAYER,
  ENEMY
}

/** Clase que representa las balas del jugador */
private class Bullet extends GameObject implements IVisualizable {
  /* -- ATRIBUTOS -- */
  /** Representa la velocidad de la bala */
  protected float speed;
  /** Representa la dirección de la bala */
  protected PVector direction;
  /** Representa el area de colision de la bala */
  protected Colisionador colisionador;
  private BulletOwner pertenece;
  
  /** Representan los sprites de las balas del jugador y del jefe respectivamente */
  protected SpriteObject spritePlayer;
  protected SpriteObject spriteBoss;

  /** Representa el angulo de hacia donde va la bala */
  protected float angulo;
  /* Representa el estado de la bala, si esta disparada o esta orbitando*/
  protected boolean disparada;
  protected float damage;
  
  /* -- CONSTRUCTORES -- */
  /** Constructor parametrizado */
  public Bullet(PVector pos, int ancho, int alto, PVector direction, float speed, BulletOwner owner, float damage){
    super(pos, ancho, alto);
    this.pertenece = owner;
    this.direction = direction;
    this.damage =damage;
    this.speed = speed;
    if(owner == BulletOwner.PLAYER){
      this.spritePlayer = new SpriteObject("playerBullet.png", ancho, alto, 3);
    } else {
      this.spriteBoss = new SpriteObject("enemyBullet.png", ancho, alto, 3);
    }
    this.colisionador = new Colisionador(this.posicion, ancho*3); 
    this.disparada = true;
  }

  /** Constructor para balas con angulo para el enemigo */
  public Bullet(PVector pos, float angulo){
    super(pos, 8, 8);
    this.pertenece = BulletOwner.ENEMY; 
    this.angulo = angulo;
    this.speed = 400;
    this.spriteBoss = new SpriteObject("bossBullet1.png", ancho, alto, 3);
    this.disparada = true;
    this.colisionador = new Colisionador(this.posicion, ancho*3); 
  }
  
  /** Constructor para balas que orbitan para el enemigo */
  public Bullet(PVector posicion, float angulo, float radioOrbita) {
    super(posicion.copy().add(PVector.fromAngle(angulo).mult(radioOrbita)), 8, 8);
    this.pertenece = BulletOwner.ENEMY; 
    this.angulo = angulo;
    this.speed = 150;
    this.spriteBoss = new SpriteObject("bossBullet2.png", ancho, alto, 4);
    this.disparada = false;
    this.colisionador = new Colisionador(this.posicion, ancho*4); 
    this.disparada = false;
  }

  /* -- METODOS -- */
  /** Método para dibujar las balas (implementando la interfaz IVisualizable) */
  public void display() {
    if(this.pertenece == BulletOwner.PLAYER){
    tint(#FFFFFF);
      this.spritePlayer.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(this.posicion.x, this.posicion.y));
    }else{      
      this.spriteBoss.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(this.posicion.x, this.posicion.y));
    }
    //colisionador.display(color(255,0,0));
    
    //  Dibujar linea de direcciion
    stroke(0, 255, 0); // verde
    //if (disparada && direction != null) {
    //  stroke(0, 255, 0);
    //  line(
    //    posicion.x, posicion.y, 
    //    posicion.x + direction.x * 50,
    //    posicion.y + direction.y * 50
    //  );
    //}
  }
  
  /** Metodo para mover las balas */
  public void mover() {
    if (this.direction != null){
      this.posicion.add(this.direction.copy().mult(this.speed).copy().mult(Time.getDeltaTime(frameRate)));
      colisionador.setPosicion(posicion);
    }
  }

 public void moverAng() {
    
    // Cálculo del movimiento en ángulo
    PVector moveVector = PVector.fromAngle(angulo).mult(speed).mult(Time.getDeltaTime(frameRate));
    
    // Añadir oscilación sinusoidal al movimiento
    float amplitude = 2; // Amplitud de la oscilación
    float frequency = 0.5; // Frecuencia de la oscilación
    float oscillation = amplitude * sin(frequency * (millis() / 1000.0));
    
    // Ajustar el movimiento según la oscilación
    PVector oscillationVector = new PVector(oscillation * cos(angulo + HALF_PI), oscillation * sin(angulo + HALF_PI));
    moveVector.add(oscillationVector);
    
    // Actualizar la posición de la bala
    this.posicion.add(moveVector);
    this.colisionador.setPosicion(this.posicion);

}
  public boolean balaFuera() {
    return posicion.x < 0 || posicion.x > width || posicion.y < 0 || posicion.y > height;
  }
  
  public void disparar() {
    disparada = true;
    this.direction = PVector.fromAngle(angulo);
  }
  /** Verifica la colision del colisionador con los enemigos */
  public boolean verificarColision(Enemy enemigo) {
    // Verifica que el enemigo no sea el propietario de la bala
    if (this.pertenece == BulletOwner.PLAYER && colisionador.colisionaCon(enemigo.getCollider())) {
      enemigo.reducirVida();
      return true;
    }
    return false;
  }
  
  public BulletOwner getOwner() { return this.pertenece; }
  public Colisionador getCollider() { return this.colisionador; }
  public PVector getDirection() { return this.direction; }
  public boolean isDisparada() { return this.disparada; }
}
