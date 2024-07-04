/** Clase que Puerta se dibuja y verifica colisiones con el jugador */
class Door extends GameObject {
  /** Representa el nombre de la direccion de la puerta */
  private String direction;
  /** Representa el estado de la puerta, si esta abierta o cerrada */
  private boolean isOpen;

  /* -- CONSTRUCTORES -- */
  /** Constructor por defecto */
  public Door(PVector posicion, String direction) {
    this.posicion = posicion;
    this.ancho = 60;
    this.isOpen = true;
    this.direction = direction;
  }
  /* -- METODOS -- */
  /** Metodo que dibuja a la habitacion*/
  public void display() {
    stroke(0);
    noStroke();
    if (isOpen) {
      fill(0, 255, 0); // Color verde para puertas abiertas
    } else {
      fill(255, 0, 0); // Color rojo para puertas cerradas
    }
    circle(this.posicion.x, this.posicion.y, this.ancho);
  }

  /** Metodo que devuelve si la puerta coliciono o no con un objeto Player */
  public boolean isColliding(Player player) {
    return dist(this.posicion.x, this.posicion.y, player.posicion.x, player.posicion.y) < (this.ancho + player.ancho) / 2;
  }
  /* -- ASESORES -- */
  /* Getters */
  /** Devuelve el nombre de la direccion en donde se encuentra la puerta*/
  public String getDirection() {
    return this.direction;
  }
  /** Devuelve si la puerta esta abierta */
  public boolean getIsOpen() {
    return this.isOpen;
  }
  
  /* Setings */
  /** Asigna un nuevo estado a la puerta */
  public void setIsOpen(boolean state) {
    this.isOpen = state;
  }
}
