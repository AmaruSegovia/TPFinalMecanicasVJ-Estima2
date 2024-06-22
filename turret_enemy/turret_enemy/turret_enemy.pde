Torreta [] torretas;
PJ pj;
int numTorretas=4;
ArrayList<Bala> balas;
int ultimaBala = 0;
int intervaloBala = 5000;

void setup() {
  size(800, 800);
  torretas = new Torreta[numTorretas];
  for (int i = 0; i < numTorretas; i++) {
    torretas[i] = new Torreta();
  }
  pj= new PJ();
  balas = new ArrayList<Bala>();
}

void draw() {
  background(#585858);

  for (int i = 0; i < numTorretas; i++) {
    torretas[i].dibujar();
    torretas[i].detectar(pj, balas);
  }
    pj.dibujar();
    
  for (int i = 0; i < balas.size(); i++) {
    Bala b = balas.get(i);
    b.dibujar();
    b.actualizar();
  }
}
