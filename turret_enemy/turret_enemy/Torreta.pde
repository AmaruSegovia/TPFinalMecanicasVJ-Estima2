class Torreta {
  private float x, y;
  private int ultimaBala = 0;
  private int intervaloBala = 1000;

  Torreta() {
    x = random(0, width - 20);
    y = random(0, height - 40);
  }

  void dibujar() {
    rect(x, y, 20, 40);
  }
  void detectar(PJ pj, ArrayList<Bala> balas) {
    float centroX=x+10;
    float centroY=y+20;

    float vectorX = pj.getX() - centroX;
    float vectorY = pj.getY() - centroY;

    float productoPunto = vectorX * vectorX + vectorY * vectorY;

    float radioDeteccion = 100;
    if (productoPunto <= radioDeteccion * radioDeteccion) {
      fill(255);
      textSize(32);
      text("Detectado", 50, 50);
      
      if (millis() - ultimaBala >= intervaloBala) {
        Bala nuevaBala = new Bala(centroX, centroY, pj);
        balas.add(nuevaBala);
        ultimaBala=millis();
      }
    }
  }
}
