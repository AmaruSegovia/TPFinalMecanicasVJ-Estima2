class Tower extends Enemy implements IVisualizable {
  private float fireRate;
  private float lastFireTime;
  private ArrayList<Bala> balas;
  private float currentAngle;  // Nuevo campo para guardar el ángulo actual de la torreta

  /* -- CONSTRUCTOR -- */
  public Tower(PVector posicion) {
    super(posicion, 2, color(255, 255, 255));
    this.ancho = 22;
    this.alto = 22;
    this.fireRate = 0.5f;
    this.lastFireTime = millis() / 1000.0f;
    this.balas = new ArrayList<Bala>();
    this.collider = new Colisionador(this.posicion, this.ancho * 3);
    this.sprite = new SpriteObject("turret.png", ancho, alto, 3);
    this.currentAngle = 0;  // Inicializamos el ángulo actual
  }

  /* -- MÉTODOS -- */
  /** Método que dibuja a la Torre */
  public void display() {
    if (isHit) {
      float elapsed = millis() - hitTime;
      if (elapsed < hitDuration) {
        float lerpFactor = elapsed / hitDuration;
        currentColor = lerpColor(color(255, 0, 0), originalColor, lerpFactor);
      } else {
        isHit = false;
        currentColor = originalColor;
      }
    } else {
      currentColor = originalColor;
    }

    tint(currentColor);
    noStroke();

    // Rotamos la torreta hacia el jugador
    rotateTower(jugador);

    for (Bala bala : balas) {
      bala.display();
    }
    dibujarBarraVida(2, 40, 5, 35);
  }

  public void detectar(Player player) {
    PVector centro = new PVector(posicion.x, posicion.y);
    PVector vectorDireccion = PVector.sub(player.posicion, centro);
    float productoPunto = vectorDireccion.dot(vectorDireccion);

    float radioDeteccion = 300;
    float radioDeteccionCuadrado = radioDeteccion * radioDeteccion;

    if (productoPunto <= radioDeteccionCuadrado) {
      float currentTime = millis() / 1000.0f;
      if (currentTime - lastFireTime >= fireRate) {
        Bala nuevaBala = new Bala(centro.x, centro.y, player.posicion);
        balas.add(nuevaBala);
        lastFireTime = currentTime;
      }
    }

    for (int i = balas.size() - 1; i >= 0; i--) {
      Bala b = balas.get(i);
      b.mover();
      if (b.checkCollisionWithPlayer(player) || b.estaFuera()) {
        balas.remove(i);
      }
    }
  }

  public void rotateTower(Player jugador) {
    PVector direccion = PVector.sub(jugador.posicion, this.posicion);
    float angulo = atan2(direccion.y, direccion.x); 
    this.currentAngle = angulo;

    pushMatrix();
    translate(this.posicion.x, this.posicion.y);
    rotate(this.currentAngle);
    this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(0, 0));  // Dibujamos la torreta rotada en el origen de la transformación
    popMatrix();
  }
}
