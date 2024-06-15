/** Clase que Puerta se dibuja y verifica colisiones con el jugador */
class Door extends GameObject{
  /** Representa el nombre de la direccion de la puerta */
  private String direction;
  
  /* -- CONSTRUCTORES -- */
  /** Constructor por defecto */
  public Door(PVector posicion, String direction) {
    this.posicion = posicion;
    this.ancho = 60;
    this.direction = direction;
  }
  /* -- METODOS -- */
  /** Metodo que dibuja a la habitacion*/
  public void display() {
    fill(255, 0, 0);
    circle(this.posicion.x, this.posicion.y, this.ancho);
  }
  
  /** Metodo que devuelve si la puerta coliciono o no con un objeto Player */
  public boolean isColliding(Player player) {
    println("quespp");  
    return dist(this.posicion.x, this.posicion.y, player.posicion.x, player.posicion.y) < (this.ancho + player.ancho) / 2;

}
  /* -- ASESORES -- */
  /* Getters */
  /** Devuelve el nombre de la direccion en donde se encuentra la puerta*/
  public String getDirection(){
    return this.direction;
  }
}
