class Bala {
  private float x, y;
  private float dirX, dirY;
  private float velocidad = 8;
  private PJ pj; 

  Bala(float xInicial, float yInicial, PJ pj) {
    x = xInicial;
    y = yInicial;
    this.pj = pj;
    calcularDireccion();
  }

  void calcularDireccion() {
    float vectorX = pj.getX() - x;
    float vectorY = pj.getY() - y;
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
