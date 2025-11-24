class Tower extends Enemy implements IVisualizable, IShooter{
  private float fireRate;
  private float lastFireTime;
  private float anguloRotacion;

  /* -- CONSTRUCTOR -- */
  public Tower(PVector posicion) {
    super(posicion, 5, color(255, 255, 255));
    this.ancho = 22;
    this.alto = 22;
    this.fireRate = 0.8f;
    this.lastFireTime = millis() / 1000.0f;
    this.collider = new Colisionador(this.posicion, this.ancho * 3);
    this.sprite = new SpriteObject("turret.png", ancho, alto, 3);
    this.anguloRotacion = 0;
  }

  /* -- MÉTODOS -- */
  @Override
  public void update(Player player, Room room){
    updateHitEffect();
    checkCollisionWithPlayer(player);
    rotateTower(player);
  }
  /** Método que dibuja a la Torre */
  @Override
  public void display(){
    tint(currentColor);
    noStroke();

    // Rotar y dibujar la torre
    pushMatrix();
      translate(this.posicion.x, this.posicion.y);
      rotate(anguloRotacion);
      this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(0, 0));  // Dibujamos la torreta rotada en el origen de la transformación
    popMatrix();

    dibujarBarraVida(5, 40, 5, 35);
  }

  public void shoot(Player player, GestorBullets gestorBalas) {
    PVector centro = this.posicion.copy();
    PVector vectorDireccion = PVector.sub(player.getPosicion(), centro);
    
    float productoPunto = vectorDireccion.dot(vectorDireccion);

    float radioDeteccion = 500;
    float radioDeteccionCuadrado = radioDeteccion * radioDeteccion;

    if (productoPunto <= radioDeteccionCuadrado) {
      float currentTime = millis() / 1000.0f;
      if (currentTime - lastFireTime >= fireRate) {
        vectorDireccion.normalize();
        
        // Crear bala ENEMY con direccion fija hacia el jugador
            Bullet nuevaBala = new Bullet(
                centro.copy(),
                8, 8,
                vectorDireccion,
                300,
                BulletOwner.ENEMY
            );

            gestorBalas.addBullet(nuevaBala); // agregar al gestor
            lastFireTime = currentTime;       // actualizar temporizador
      }
    }
  }
  

  public void rotateTower(Player jugador) {
    // Vector desde la torre hacia el jugador
    PVector direccion = PVector.sub(jugador.getPosicion(), this.posicion);

    // Vector que representa la dirección original de la torre (hacia la derecha)
    PVector direccionInicial = new PVector(1, 0);

    // Calcular el ángulo entre los dos vectores
    float angulo = PVector.angleBetween(direccionInicial, direccion);

    // Calcular el producto cruz entre la dirección inicial y la dirección hacia el jugador
    PVector productoCruz = direccionInicial.cross(direccion);

    // Determinar el sentido de rotación
    int sentidoHorario = (productoCruz.z < 0) ? -1 : 1;
    anguloRotacion = angulo * sentidoHorario;
  }

}
