class Player extends GameObject {

  /** Representa la direccion de movimiento del jugador */
  private PVector direccion;

  public Player() {
  }

  public Player(PVector posicion) {
    this.posicion = posicion;
    this.ancho = 25;

    this.direccion = new PVector(this.posicion.x,this.posicion.y+30);
  }

  public void display() {
    fill(200, 30);
    circle(this.posicion.x, this.posicion.y, ancho*2);
    textSize(50);
    fill(255);
    
    strokeWeight(2);
    stroke(#EBFF6A);
    line(this.posicion.x, this.posicion.y, this.direccion.x, this.direccion.y);

  }
}
