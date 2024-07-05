/** Clase que Puerta se dibuja y verifica colisiones con el jugador */
class Door extends GameObject {
  /** Representa el nombre de la direccion de la puerta */
  private String direction;
  /** Representa el estado de la puerta, si esta abierta o cerrada */
  private boolean isOpen;
  /** Representa el area de colision de la puerta */
  private Colisionador collider;

  /* -- CONSTRUCTORES -- */
  /** Constructor para puertas con posicion variada */
  public Door(PVector posicion, String direction) {
    this.posicion = posicion;
    this.ancho = 60;
    this.isOpen = true;
    this.direction = direction;
    this.collider = new Colisionador(this.posicion,this.ancho-20);
  }
  /** Constructor para puertas con posiciones fijas */
  public Door(String direction) {
    this.ancho = 60;
    this.direction = direction;
    this.isOpen = true;
    
    if (this.direction.equals("UP")){
      this.posicion = new PVector(width / 2, 35);
    } else if(this.direction.equals("RIGHT")) {
      this.posicion = new PVector(width-35, height / 2);
    } else if(this.direction.equals("DOWN")){
      this.posicion = new PVector(width / 2, height-35);
    }else if (this.direction.equals("LEFT")){
      this.posicion = new PVector(35, height / 2);
    }
    this.collider = new Colisionador(this.posicion,this.ancho-20);
  }
  /* -- METODOS -- */
  /** Metodo que dibuja a la habitacion*/
  public void display() {
    noStroke();
    if (isOpen) {
      fill(0, 255, 0); // Color verde para puertas abiertas
    } else {
      fill(255, 0, 0); // Color rojo para puertas cerradas
    }
    circle(this.posicion.x, this.posicion.y, this.ancho);
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
