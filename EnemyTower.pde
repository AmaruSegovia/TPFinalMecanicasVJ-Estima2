class Tower extends Enemy implements IVisualizable {
  private float fireRate;
  private float lastFireTime;
  private ArrayList<Bala> balas;

  public Tower(PVector posicion) {
    super(posicion, 2, color(255, 255, 0)); // color inicial amarillo
    this.fireRate = 0.5;
    this.lastFireTime = millis() / 1000.0;
    this.balas = new ArrayList<Bala>();
  }

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

    fill(currentColor);
    noStroke();
    rect(posicion.x - ancho / 2, posicion.y - alto / 2, ancho, alto);

    for (Bala bala : balas) {
      bala.dibujar();
    }

    dibujarBarraVida(2, 40, 5, 35);
  }

  public void detectar(Player player) {
    PVector centro = new PVector(posicion.x, posicion.y);
    PVector vectorDireccion = PVector.sub(player.posicion, centro);
    float productoPunto = vectorDireccion.dot(vectorDireccion);

    float radioDeteccion = 180;
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
      b.actualizar();
      if (b.estaFuera()) {
        balas.remove(i);
      }
    }
  }

  class Bala {
    private float x, y;
    private float dirX, dirY;
    private float velocidad = 5;

    Bala(float xInicial, float yInicial, PVector objetivo) {
      x = xInicial;
      y = yInicial;
      float vectorX = objetivo.x - xInicial;
      float vectorY = objetivo.y - yInicial;
      float magnitud = sqrt(vectorX * vectorX + vectorY * vectorY);
      dirX = vectorX / magnitud;
      dirY = vectorY / magnitud;
    }

    void actualizar() {
      x += dirX * velocidad;
      y += dirY * velocidad;
    }

    void dibujar() {
      ellipse(x, y, 10, 10);
    }

    boolean estaFuera() {
      return (x < 0 || x > width || y < 0 || y > height);
    }
  }
}
