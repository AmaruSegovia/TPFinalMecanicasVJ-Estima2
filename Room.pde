enum RoomType {
  NORMAL,
  BOSS,
  TREASURE,
  SUBBOSS
}
/** Clase que representa las habitaciones de la dungeon */
class Room extends GameObject {
  /** Representa las posiciones de las puertas en binario */
  private int doors;
  /** Representa la lista de puertas que tiene la habitacion*/
  private Map<Direction, Door> doorsMap = new HashMap<>();
  
  /** Representa el nombre de la habitacion */
  private int nameRoom;
 
  /** Representa el fondo de la habitación */
  private PImage background;
  
  private RoomType type = RoomType.NORMAL; // por defecto normal

  /* -- CONSTRUCTORES -- */
  /** Constructor parametrizado */
  public Room(int doors, int ancho, int alto, PVector posicion, int name) {
    super(posicion, ancho, alto);
    this.doors = doors;
    this.nameRoom = name;
    background = loadImage("bg.png");
    generateDoors();
  }

  /* -- METODOS -- */
  /** Metodo que genera las puertas segun el numero de la matriz sus binarios */
  public void generateDoors() {
    // Comprobacion AND bit a bit para saber si hay una puerta en X direccion
    // Se comparan los bits del valor de la matriz con otro para limpiar bits
    if ((this.doors & 1) != 0) doorsMap.put(Direction.UP, new Door(Direction.UP));
    if ((this.doors & 2) != 0) doorsMap.put(Direction.RIGHT, new Door(Direction.RIGHT));
    if ((this.doors & 4) != 0) doorsMap.put(Direction.DOWN, new Door(Direction.DOWN));
    if ((this.doors & 8) != 0) doorsMap.put(Direction.LEFT, new Door(Direction.LEFT));
  }

  /** Metodo que dibuja la room y las puertas */
  public void display() {
    noStroke();
    imageMode(CORNER);
    tint(255);
    
    image(background, 0, 0, 900, 800);
    for (Door door : this.doorsMap.values()) {
      if (door != null) door.display();
    }
  }

  /** Metodo que devuelve si hay puertas en la habitacion*/
  public boolean hasDoors() {
    for (Door door : this.doorsMap.values()) {
      if (door != null) return true; // verifica si el objeto door no es null.
    }
    //println("no hay puertas!! estas encerrado!! >:3");
    return false;
  }
  
  /** Metodo que verifica y actualiza el estado de las puertas*/
  private void updateDoors(boolean hayEnemies){
    if(hayEnemies){
      stateDoors(false);
    } else {
      stateDoors(true);
    }
  }
  
  /** Metodo que cierra o abre las puertas */
  public void stateDoors(boolean state) {
    for (Door door : doorsMap.values()) {
      door.setIsOpen(state);
    }
  }
  
  /**Imprime cantidad de enemigos y puertas, depuracion **/
  public void debugInfo() {
    println("Room at " + posicion + " | Doors: " + doorsMap.size());
  }

  /* -- ASESORES -- */
  
  /** Devuelve la puerta de la direccion solicitada */
  public Door getDoor(Direction dir) {
    return doorsMap.get(dir);
  }
  
  public Collection<Door> getAllDoors(){
    return this.doorsMap.values();  
  }
  
  public void setNameRoom(int name) {
    this.nameRoom = name;
  }
  public int getNameRoom() {
    return this.nameRoom;
  }
  
  public void setType(RoomType type) { this.type = type; }
  public RoomType getType() { return type; }
}
