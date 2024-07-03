class Enemy extends GameObject implements IVisualizable {
  private float fireRate;
  private float lastFireTime;

  public Enemy(PVector posicion) {
    super(posicion, 40, 40);
    this.fireRate = 1.0;
    this.lastFireTime = millis() / 1000.0;
  }

  public void display() {
    fill(255, 0, 0);
    noStroke();
    rect(posicion.x - ancho / 2, posicion.y - alto / 2, ancho, alto);
  }
  public void detectar(Player player){
   PVector centro = new PVector (posicion.x,posicion.y);
     PVector vectorDireccion= PVector.sub(player.posicion,centro);
     float distancia= vectorDireccion.mag();
     
     float radioDeteccion=100;
     if(distancia<=radioDeteccion){
      textSize(20);
      text("Detectao",50,50);
     }
  }
}
  
