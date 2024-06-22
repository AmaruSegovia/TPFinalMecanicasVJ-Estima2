Torreta torreta;
PJ pj;

void setup() {
  size(800, 800);
  torreta= new Torreta();
  pj= new PJ();
}

void draw() {
  background(#585858);
  pj.dibujar();
  torreta.dibujar();
  torreta.detectar(pj);
}
 
