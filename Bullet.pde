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
  public Bullet(PVector pos, float angulo,String pertenece){
    this.pertenece = pertenece; 
    this.posicion = pos;
    this.ancho = 8;
    this.alto = 8;
    this.angulo = angulo;
    this.speed = 400;
    this.spriteBoss = new SpriteObject("bossBullet1.png", ancho, alto, 3);
    this.disparada = true;
    this.colisionador = new Colisionador(this.posicion, ancho*3); 
  }
  
  /** Constructor para balas que orbitan para el enemigo */
  Bullet(PVector posicion, float angulo, float radioOrbita,String pertenece) {
    this.pertenece = pertenece; 
    this.posicion = posicion.copy().add(PVector.fromAngle(angulo).mult(radioOrbita));
    this.angulo = angulo;
    this.speed = 150;
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

        // Parámetros para la oscilación radial
        float baseRadio = 100; // Radio base de la órbita
        float amplitude = 250; // Amplitud de la oscilación
        float frequency = 0.7; // Frecuencia de la oscilación

        // Calcular la oscilación radial
        float radialOscillation = baseRadio + amplitude * sin(frequency * (millis() / 1000.0));

        // Actualizar la posición de la bala con la oscilación radial
        this.posicion.x = bossPosition.x + radialOscillation * cos(angulo);
        this.posicion.y = bossPosition.y + radialOscillation * sin(angulo);
    }
    
    if (colisionador.isCircle(jugador.collider) && !jugador.isHit) {
        jugador.reducirVida();
    }
}

  
 public void moverAng() {
    colisionador.setPosicion(this.posicion);
    
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
    
    // Verificar colisión con el jugador
    if (colisionador.isCircle(jugador.collider) && !jugador.isHit) {
        jugador.reducirVida();
    }
}

  
  public void disparar() {
    disparada = true;
    this.direction = PVector.fromAngle(angulo);
  }
  /** Verifica la colision del colisionador con los enemigos */
  public boolean verificarColision(Enemy enemigo) {
    // Verifica que el enemigo no sea el propietario de la bala
    if (this.pertenece == "jugador" && colisionador.isCircle(enemigo.collider)) {
        enemigo.reducirVida();
        return true;
    }
    return false;
}

}
