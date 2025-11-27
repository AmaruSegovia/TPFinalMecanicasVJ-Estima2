/** Clase que Puerta se dibuja y verifica colisiones con el jugador */
class Door extends GameObject {
  // --- Constantes ---
  private static final int DEFAULT_SIZE = 60;
  private static final float ENTRY_OFFSET = 1.2f;
  
  // --- Atributos ---
  /** Representa el nombre de la direccion de la puerta */
  private Direction direction;
  /** Representa el estado de la puerta, si esta abierta o cerrada */
  private boolean isOpen;
  /** Representa el area de colision de la puerta */
  private Colisionador collider;
  
  private Room targetRoom;

  /* -- CONSTRUCTORES -- */
  /** Constructor para puertas con posicion variada */
  public Door(PVector posicion, Direction direction) {
    this.posicion = posicion;
    this.ancho = DEFAULT_SIZE;
    this.isOpen = true;
    this.direction = direction;
    this.collider = new Colisionador(this.posicion,this.ancho-20);
  }
  /** Constructor para puertas con posiciones fijas */
  public Door(Direction direction) {
    this.posicion = directionToPosition(direction);
    this.ancho = DEFAULT_SIZE;
    this.isOpen = true;
    this.direction = direction;
    this.collider = new Colisionador(this.posicion, this.ancho - 20);
  }

  // --- Métodos auxiliares ---
  private PVector directionToPosition(Direction dir) {
    switch (dir) {
      case UP:    return new PVector(width / 2, 35);
      case RIGHT: return new PVector(width - 35, height / 2);
      case DOWN:  return new PVector(width / 2, height - 35);
      case LEFT:  return new PVector(35, height / 2);
      default:    return new PVector(width / 2, height / 2);
    }
  }
  /* -- METODOS -- */
  /** Metodo que dibuja a la habitacion*/
  public void display() {
    noStroke();
    
    if (targetRoom != null && targetRoom.getType() == RoomType.BOSS) {
      fill(255, 255, 0); // amarillo
    } else {
      if (isOpen) {
      fill(0, 255, 0); // Color verde para puertas abiertas
    } else {
      fill(255, 0, 0); // Color rojo para puertas cerradas
    }
    }
    circle(this.posicion.x, this.posicion.y, this.ancho);
  }

  /* -- ASESORES -- */
  /* Getters */
  /** Devuelve el nombre de la direccion en donde se encuentra la puerta*/
  public Direction getDirection() {
    return this.direction;
  }
  /** Devuelve si la puerta esta abierta */
  public boolean getIsOpen() {
    return this.isOpen;
  }
  /** Obtener la posicion de entrada **/
  public PVector getEntryPosition() {
    float offset = this.ancho * ENTRY_OFFSET;
    switch (direction) {
      case UP:    return new PVector(posicion.x, posicion.y + offset);
      case DOWN:  return new PVector(posicion.x, posicion.y - offset);
      case LEFT:  return new PVector(posicion.x + offset, posicion.y);
      case RIGHT: return new PVector(posicion.x - offset, posicion.y);
      default:    return posicion.copy();
    }
  }

  /* Setings */
  /** Asigna un nuevo estado a la puerta */
  public void setIsOpen(boolean state) {
    this.isOpen = state;
  }
  public Colisionador getCollider() { return collider; }
}
