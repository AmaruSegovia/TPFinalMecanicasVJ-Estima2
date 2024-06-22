class Torreta {
  private float x, y;
  Torreta() {
    x = random(0, width - 20); 
    y = random(0, height - 40);
  }

  void dibujar() {
    rect(x, y, 20, 40);
  }
  void detectar(PJ pj) {
    float centroX=x+10;
    float centroY=y+20;
    
    float distancia = dist(centroX, centroY, pj.getX(), pj.getY());
    
    if (distancia<=50){
      fill(255);
      textSize(32);
      text("detectao",50,50);
    }
  }
}
