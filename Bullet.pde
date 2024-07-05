/** Clase que representa las balas del jugador */
private class Bullet extends GameObject implements IMovable, IVisualizable {
  /* -- ATRIBUTOS -- */
  /** Representa la velocidad de la bala */
  private float speed;
  /** Representa la dirección de la bala */
  private PVector direction;
  /** Representa el area de colision de la bala */
  private Colisionador colisionador;
  private String pertenece;
  
  /** Representan los sprites de las balas del jugador y del jefe respectivamente */
  private SpriteObject spritePlayer;
  private SpriteObject spriteBoss;

  /** Representa el angulo de hacia donde va la bala */
  private float angulo;
  /* Representa el estado de la bala, si esta disparada o esta orbitando*/
  private boolean disparada;
  
  /* -- CONSTRUCTORES -- */
  /** Constructor parametrizado */
  public Bullet(PVector pos, int ancho, int alto, PVector direction, float speed, String pertenece) {
    super(pos, ancho, alto);
    this.pertenece = pertenece; 
    this.direction = direction;
    this.speed = speed;
    this.spritePlayer = new SpriteObject("playerBullet.png", ancho, alto, 3);
    this.colisionador = new Colisionador(this.posicion, ancho*3); 
    this.disparada = true;
  }
  /** Constructor para balas con angulo para el enemigo */
  public Bullet(PVector pos, float angulo){
    this.posicion = pos;
    this.ancho = 8;
    this.alto = 8;
    this.angulo = angulo;
    this.speed = 150;
    this.spriteBoss = new SpriteObject("bossBullet1.png", ancho, alto, 3);
    this.disparada = true;
    this.colisionador = new Colisionador(this.posicion, ancho*3); 
  }
  
  /** Constructor para balas que orbitan para el enemigo */
  Bullet(PVector posicion, float angulo, float radioOrbita) {
    this.posicion = posicion.copy().add(PVector.fromAngle(angulo).mult(radioOrbita));
    this.angulo = angulo;
    this.speed = 300;
    this.alto = 8;
    this.ancho = 8;
    this.spriteBoss = new SpriteObject("bossBullet2.png", ancho, alto, 4);
    this.disparada = false;
    this.colisionador = new Colisionador(this.posicion, ancho*4); 
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
    imageMode(CENTER);
    if(this.pertenece == "jugador"){
    tint(#FFFFFF);
      this.spritePlayer.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(this.posicion.x, this.posicion.y));
    }else{      
      this.spriteBoss.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(this.posicion.x, this.posicion.y));
    }
  }
  

  public void orbitar(PVector bossPosition) {
    if (!disparada) {
      this.angulo += 0.03; // Velocidad de la órbita
      posicion = bossPosition.copy().add(PVector.fromAngle(angulo).mult(100));
    }
    if (colisionador.isCircle(jugador.collider)&& !jugador.isHit) {
      jugador.reducirVida();
    }
  }
  
  public void moverAng() {
    colisionador.setPosicion(this.posicion);
    this.posicion.add(PVector.fromAngle(angulo).mult(speed).mult(Time.getDeltaTime(frameRate)));
    if (colisionador.isCircle(jugador.collider)&& !jugador.isHit) {
      jugador.reducirVida();
    }
  }
  
  public void disparar() {
    disparada = true;
    this.direction = PVector.fromAngle(angulo);
  }
  /** Verifica la colision del colisionador con los enemigos */
  public boolean verificarColision(Enemy enemigo) {
    if (colisionador.isCircle(enemigo.collider)) {
      enemigo.reducirVida();
      return true;
    }
    return false;
  }
}
