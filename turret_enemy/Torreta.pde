 class Torreta {
  private int radio;
  private float x, y;
  Torreta() {
    x=width/2;
    y=200;
    radio=50;
  }

  void dibujar() {
    rect(x, y, 20, 40);
    float centroX=x+10;
    float centroY=y+20;
    ellipse(centroX, centroY, radio*2, radio*2);
  }
