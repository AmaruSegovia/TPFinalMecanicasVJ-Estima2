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
      println("RoomVisual no registrado para: " + type);
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
  private boolean isStart = false;

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
  
  
  public void checkColectable(Player p, Notificaciones notifications) {
    for (int i = collectibles.size()-1; i >= 0; i--) {
      Collectible c = collectibles.get(i);
      c.update(p, notifications);

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
  public void setIsStart(boolean s) { this.isStart = s; }
  public boolean isStart() { return this.isStart; }
  
  /** Hooks polimórficos para lógica y UI específica de cada sala */
  public void handleRoomLogic(GestorEnemigos gestor, Player player) {}
  public void renderRoomUI(RoomRenderer renderer) {}
}

/* -- SUBCLASES ESPECIALIZADAS -- */

class StartRoom extends Room {
  private PImage tutorialWASD;
  private PImage tutorialIJKL;

  public StartRoom(int doors, int name) {
    super(doors, name);
    this.setIsStart(true);
    this.tutorialWASD = loadImage("wasd.png");
    this.tutorialIJKL = loadImage("ijkl.png");
  }
  
  @Override
  public void renderRoomUI(RoomRenderer renderer) {
    fill(#ccffff);
    textSize(48);
    text("Cómo Jugar", width/2, height/6);
    textSize(36);
    text("Caminar", width/4.2, height/1.5);
    text("Disparar", width/1.3, height/1.5);
    imageMode(CENTER);
    
    image(tutorialWASD, width/4.2, height/1.8, 120, 80);        
    image(tutorialIJKL, width/1.3, height/1.8, 120, 80);
  }
}

class BossRoom extends Room {
  private VictoryDoor victoryDoor;

  public BossRoom(int doors, int name) {
    super(doors, name);
    setType(RoomType.BOSS);
  }

  @Override
  public void handleRoomLogic(GestorEnemigos gestor, Player player) {
    // 1. Aparecer puerta si no hay enemigos
    if (!gestor.hayEnemigos() && !hasVictoryDoor()) {
      spawnVictoryDoor();
    }
    
    // 2. Detectar victoria al entrar en la puerta
    if (hasVictoryDoor()) {
      Door door = player.checkCollision(this);
      if (door instanceof VictoryDoor) {
        changeState(victoria);
      }
    }
  }

  /** Crear la puerta de victoria en el centro */
  public void spawnVictoryDoor() {
    if (victoryDoor == null) {
      victoryDoor = new VictoryDoor(new PVector(width/2, height/2));
      addDoor(Direction.UP, victoryDoor); 
    }
  }

  public boolean hasVictoryDoor() {
    return victoryDoor != null;
  }

  public VictoryDoor getVictoryDoor() {
    return victoryDoor;
  }
}

class TreasureRoom extends Room {
  public TreasureRoom(int doors, int name) {
    super(doors, name);
    setType(RoomType.TREASURE);
    // Auto-generar contenido inicial
    CollectibleFactory factory = new CollectibleFactory();
    Collectible chest = factory.randomTreasure(getCenterPosition());
    if (chest != null) addCollectible(chest);
  }
}

class SubBossRoom extends Room {
  public SubBossRoom(int doors, int name) {
    super(doors, name);
    setType(RoomType.SUBBOSS);
  }

  @Override
  public void handleRoomLogic(GestorEnemigos gestor, Player player) {
    if (!gestor.hayEnemigos() && !hasLootSpawned()) {
      markLootSpawned();
      CollectibleFactory factory = new CollectibleFactory();
      Collectible drop = factory.randomTreasure(getCenterPosition());
      if (drop != null) addCollectible(drop);
    }
  }
}
