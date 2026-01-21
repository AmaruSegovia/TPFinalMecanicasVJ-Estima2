class LifeBar {

  private float barraAncho;
  private float barraAlto;
  private float offsetY;

  public LifeBar(float barraAncho, float barraAlto, float offsetY) {
    this.barraAncho = barraAncho;
    this.barraAlto = barraAlto;
    this.offsetY = offsetY;
  }

  public void draw(PVector posicion, int lives, int maxLives) {
    if (maxLives <= 0) return;
    float porcentaje = (float) lives / maxLives;   // proporción de vida
    porcentaje = constrain(porcentaje, 0, 1);

    float anchoActual = porcentaje * barraAncho;   // ancho proporcional


    // Interpolacion lineal del color de verde (vida completa) a rojo (sin vida)
    float r = map(lives, 0, maxLives, 255, 0);
    float g = map(lives, 0, maxLives, 0, 255);

    noStroke();
    fill(r, g, 0);
    rect(posicion.x - barraAncho / 2, posicion.y - offsetY, anchoActual, barraAlto);

    noFill();
    stroke(0);
    rect(posicion.x - barraAncho / 2, posicion.y - offsetY, barraAncho, barraAlto);
  }
  
  void drawBoss(float lives, float maxLives) {
    float margen = 60;
    float barraAncho = width - margen * 2;
    float barraAlto = 22;

    float pct = lives / maxLives;
    float anchoActual = barraAncho * pct;

    float r = map(lives, 0, maxLives, 255, 0);
    float g = map(lives, 0, maxLives, 0, 255);

    fill(r, g, 0);
    rect(margen, height - 90, anchoActual, barraAlto);

    noFill();
    stroke(0);
    strokeWeight(4);
    rect(margen, height - 90, barraAncho, barraAlto);
    strokeWeight(1);
  }

}
