enum RoomType {
  NORMAL,
  BOSS,
  TREASURE,
  SUBBOSS
}

class RoomVisual {
  PImage background;

  public RoomVisual(PImage background) {
    this.background = background;
  }
  
  public void render() {
    imageMode(CORNER);
    tint(255);
    image(background, 0, 0, 900, 800);
  }
}

class RoomVisualRegistry {
  private Map<RoomType, RoomVisual> visuals = new HashMap<>();
  private RoomVisual defaultVisual;

  public void register(RoomType type, RoomVisual visual) {
    visuals.put(type, visual);
  }

  public RoomVisual get(RoomType type) {
    if (!visuals.containsKey(type)) {
      println("⚠️ RoomVisual no registrado para: " + type);
      return defaultVisual;
    }
    return visuals.get(type);
  }
}  


/** Clase que representa las habitaciones de la dungeon */
class Room {
  /** Representa la lista de puertas que tiene la habitacion*/
  protected Map<Direction, Door> doorsMap = new HashMap<>();
  /** Representa la lista de recolectables en la habitacion */
  ArrayList<Collectible> collectibles = new ArrayList<Collectible>();
  
  /** Representa el nombre de la habitacion */
  protected int nameRoom;
  
  protected RoomType type = RoomType.NORMAL; // por defecto normal
  
  private boolean lootSpawned = false;

  /* -- CONSTRUCTORES -- */
  /** Constructor parametrizado */
  public Room(int doors, int name) {
    this.nameRoom = name;
    generateDoors(doors);
  }

  /* -- METODOS -- */
  /** Metodo que genera las puertas segun el numero de la matriz sus binarios */
  public void generateDoors(int doors) {
    // Comprobacion AND bit a bit para saber si hay una puerta en X direccion
    // Se comparan los bits del valor de la matriz con otro para limpiar bits
    if ((doors & 1) != 0) doorsMap.put(Direction.UP, new Door(Direction.UP));
    if ((doors & 2) != 0) doorsMap.put(Direction.RIGHT, new Door(Direction.RIGHT));
    if ((doors & 4) != 0) doorsMap.put(Direction.DOWN, new Door(Direction.DOWN));
    if ((doors & 8) != 0) doorsMap.put(Direction.LEFT, new Door(Direction.LEFT));
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
  
  
  public void checkColectable(Player p) {
    for (int i = collectibles.size()-1; i >= 0; i--) {
      Collectible c = collectibles.get(i);
      c.update(p);

      if (c.isPicked()) {
        collectibles.remove(i);
      }
    }
  }
  
  /** Metodo que cierra o abre las puertas */
  public void stateDoors(boolean state) {
    for (Door door : doorsMap.values()) {
      door.setIsOpen(state);
    }
  }
  
  public void addDoor(Direction dir, Door door) {
    doorsMap.put(dir, door);
  }
  
  public boolean hasLootSpawned() {
    return lootSpawned;
  }

  public void markLootSpawned() {
    lootSpawned = true;
  }
  
  public void addCollectible(Collectible c) {
    collectibles.add(c);
  }

  public ArrayList<Collectible> getCollectibles() {
    return collectibles;
  }
  public PVector getCenterPosition() {
    return new PVector(width / 2, height / 2);
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

class BossRoom extends Room {
  private VictoryDoor victoryDoor;

  public BossRoom(int doors, int name) {
    super(doors, name);
    setType(RoomType.BOSS);
  }

  
  public void display() {
    noStroke();
    imageMode(CORNER);
    tint(255);
    image(background, 0, 0, 900, 800);

    // Dibujar puerta de victoria si existe
    if (victoryDoor != null) {
      victoryDoor.display();
    }
  }
  

  /** Crear la puerta de victoria en el centro */
  public void spawnVictoryDoor() {
    if (victoryDoor == null) {
      victoryDoor = new VictoryDoor(new PVector(width/2, height/2));
      addDoor(Direction.UP, victoryDoor); // usamos el metodo addDoor de Room
    }
  }

  public boolean hasVictoryDoor() {
    return victoryDoor != null;
  }

  public VictoryDoor getVictoryDoor() {
    return victoryDoor;
  }
}
