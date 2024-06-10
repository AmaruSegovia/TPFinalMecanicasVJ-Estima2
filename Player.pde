/** Clase que representa al jugador */
class Player extends GameObject {
  /** Representa la direccion de movimiento del jugador */
  private Vector direccion;

  public Player() {
  }

  public Player(PVector posicion) {
    this.posicion = posicion;
    this.ancho = 50;

    this.direccion = new Vector(this.posicion, new PVector(0,60));
  }

  public void display() {
    fill(200, 30);
    circle(this.posicion.x, this.posicion.y, ancho);
    textSize(50);
    fill(255);
    direccion.display();

  }
}
