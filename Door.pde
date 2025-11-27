/** Clase que Puerta se dibuja y verifica colisiones con el jugador */
class Door extends GameObject {
  // --- Constantes ---
  private static final int DEFAULT_SIZE = 60;
  private static final float ENTRY_OFFSET = 1.2f;
  private PImage spriteCerrada;
  private PImage spriteAbierta;
  // --- Atributos ---
  /** Representa el nombre de la direccion de la puerta */
  protected Direction direction;
  /** Representa el estado de la puerta, si esta abierta o cerrada */
  protected boolean isOpen;
  /** Representa el area de colision de la puerta */
  protected Colisionador collider;

  protected Room targetRoom;

  /* -- CONSTRUCTORES -- */
  /** Constructor para puertas con posicion variada */
  public Door(PVector posicion, Direction direction) {
    this.posicion = posicion;
    this.ancho = DEFAULT_SIZE;
    this.isOpen = true;
    this.direction = direction;
    this.collider = new Colisionador(this.posicion, this.ancho-20);
    this.cargarSprites();
  }
  /** Constructor para puertas con posiciones fijas */
  public Door(Direction direction) {
    this.posicion = directionToPosition(direction);
    this.ancho = DEFAULT_SIZE;
    this.isOpen = true;
    this.direction = direction;
    this.collider = new Colisionador(this.posicion, this.ancho - 20);
    this.cargarSprites();
  }

  // --- Métodos auxiliares ---
  private PVector directionToPosition(Direction dir) {
    switch (dir) {
      case UP:    return new PVector(width / 2, 45);
      case RIGHT: return new PVector(width - 35, height / 2);
      case DOWN:  return new PVector(width / 2, height - 45);
      case LEFT:  return new PVector(34, height / 2);
      default:    return new PVector(width / 2, height / 2);
    }
  }

  // --- Carga de imágenes ---
  private void cargarSprites() {
    // Cargamos SOLO la versión original (asumiendo que apunta hacia ARRIBA/VERTICAL)
    this.spriteCerrada = loadImage("puerta.png"); 
    this.spriteAbierta = loadImage("puerta_abierta.png");

    // Seguridad por si falta la imagen abierta
    if (this.spriteAbierta == null) this.spriteAbierta = this.spriteCerrada;
  }

  /* -- METODO DISPLAY CON ROTACIÓN -- */
  public void display() {
    noStroke();
    
    PImage spriteActual = isOpen ? spriteAbierta : spriteCerrada;

    float angulo = 0;
    
    switch (this.direction) {
      case UP:    angulo = 0; break;             // Sin rotación
      case RIGHT: angulo = HALF_PI; break;       // 90 grados a la derecha
      case DOWN:  angulo = PI; break;            // 180 grados (cabeza abajo)
      case LEFT:  angulo = -HALF_PI; break;      // -90 grados a la izquierda
    }
    pushMatrix();
      
      translate(this.posicion.x, this.posicion.y);
      
      rotate(angulo);
      imageMode(CENTER);
      
      if (targetRoom != null && targetRoom.getType() == RoomType.BOSS) {
         tint(255, 255, 0); 
      } else if (!isOpen) {
      }

      if (spriteActual != null) {
        image(spriteActual, 0, 0, 70, 70);
      } else {
        rect(0, 0, this.ancho, this.ancho);
      }
    popMatrix(); 
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
    case UP:
      return new PVector(posicion.x, posicion.y + offset);
    case DOWN:
      return new PVector(posicion.x, posicion.y - offset);
    case LEFT:
      return new PVector(posicion.x + offset, posicion.y);
    case RIGHT:
      return new PVector(posicion.x - offset, posicion.y);
    default:
      return posicion.copy();
    }
  }

  /* Setings */
  /** Asigna un nuevo estado a la puerta */
  public void setIsOpen(boolean state) {
    this.isOpen = state;
  }
  public Colisionador getCollider() {
    return collider;
  }
}

class VictoryDoor extends Door {
  private PVector posicion;
  private boolean isOpen = true;

  public VictoryDoor(PVector posicion) {
    super(Direction.NONE); // llamamos al constructor padre con algo
    this.posicion = posicion;
    this.setIsOpen(true);
  }

  @Override
    public void display() {
    fill(255, 0, 0); // rojo para diferenciar
    noStroke();
    //circle(posicion.x, posicion.y, 60); // dibujar puerta en el centro
    collider.setPosicion(this.posicion);
    //collider.display(20);
  }

  @Override
    public Colisionador getCollider() {
    return new Colisionador(posicion, 60);
  }
}
