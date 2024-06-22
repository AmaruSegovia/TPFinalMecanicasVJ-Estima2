Torreta [] torretas;
PJ pj;
int numTorretas=4;

void setup() {
  size(800, 800);
   torretas = new Torreta[numTorretas];
  for (int i = 0; i < numTorretas; i++) {
    torretas[i] = new Torreta();
  }
  pj= new PJ();
}

void draw() {
  background(#585858);
  pj.dibujar();
 for (int i = 0; i < numTorretas; i++) {
    torretas[i].dibujar();
    torretas[i].detectar(pj);
  }
}
 
