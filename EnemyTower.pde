class Tower extends Enemy implements IVisualizable {
  private float fireRate;
  private float lastFireTime;
  private ArrayList<Bala> balas;

  /* -- CONSTRUCTOR -- */
  public Tower(PVector posicion) {
    super(posicion, 5, color(255, 255, 255));
    this.ancho = 22;
    this.alto = 22;
    this.fireRate = 0.5f;
    this.lastFireTime = millis() / 1000.0f;
    this.balas = new ArrayList<Bala>();
    this.collider = new Colisionador(this.posicion, this.ancho * 3);
    this.sprite = new SpriteObject("turret.png", ancho, alto, 3);
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
    dibujarBarraVida(5, 40, 5, 35);
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
    // Vector desde la torre hacia el jugador
    PVector direccion = PVector.sub(jugador.posicion, this.posicion);

    // Vector que representa la dirección original de la torre (hacia la derecha)
    PVector direccionInicial = new PVector(1, 0);

    // Calcular el ángulo entre los dos vectores
    float angulo = PVector.angleBetween(direccionInicial, direccion);

    // Calcular el producto cruz entre la dirección inicial y la dirección hacia el jugador
    PVector productoCruz = direccionInicial.cross(direccion);

    // Determinar el sentido de rotación
    int sentidoHorario = 1;
    if (productoCruz.z < 0) {
        sentidoHorario = -1;
    }

    // Rotar y dibujar la torre
    pushMatrix();
    translate(this.posicion.x, this.posicion.y);
    rotate(angulo * sentidoHorario);
    this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(0, 0));  // Dibujamos la torreta rotada en el origen de la transformación
    popMatrix();
}

}
