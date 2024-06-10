/** Clase que representa al jugador */
class Player extends GameObject {
  /** Representa la direccion de movimiento del jugador */
  private Vector direccion;

  /** -- CONSTRUCTORES -- */
  public Player() {
  }

  public Player(PVector posicion) {
    this.posicion = posicion;
    this.ancho = 50;

    this.direccion = new Vector(this.posicion, "down");
  }

  /** -- METODOS -- */
  /** Metodo que dibuja al jugador en pantalla */
  public void display() {
    fill(200, 30);
    circle(this.posicion.x, this.posicion.y, ancho);
    textSize(50);
    fill(255);
    direccion.display();
  }
}
