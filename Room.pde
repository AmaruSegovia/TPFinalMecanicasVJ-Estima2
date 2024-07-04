/** Clase que representa las habitaciones de la dungeon */
class Room extends GameObject {
  /** Representa las posiciones de las puertas en binario */
  private int doors;
  /** Representa la lista de puertas que tiene la habitacion*/
  private Door[] doorList;
  /*representa los enemigos*/
  private ArrayList<Tower> towers;
  private ArrayList<Follower> followers;
  private ArrayList<SubBoss> subBosses;

  /* -- CONSTRUCTORES -- */
  /** Constructor por defecto */
  public Room() {
  }
  /** Constructor parametrizado */
  public Room(int doors, int ancho, int alto, PVector posicion) {
    super(posicion, ancho, alto);
    this.doors = doors;
    this.doorList = new Door[4];
     this.towers=new ArrayList<Tower>();
    this.followers = new ArrayList<Follower>();
    this.subBosses = new ArrayList<SubBoss>();
    generateDoors();
  }
  /* -- METODOS -- */
  /** Metodo que genera las puertas segun el numero de la matriz sus binarios */
  public void generateDoors() {
    // Comprobacion AND bit a bit para saber si hay una puerta en X direccion
    // Se comparan los bits del valor de la matriz con otro para limpiar bits
    if ((this.doors & 1) != 0) this.doorList[0] = new Door(new PVector(width / 2, 0), "UP");
    if ((this.doors & 2) != 0) this.doorList[1] = new Door(new PVector(width, height / 2), "RIGHT");
    if ((this.doors & 4) != 0) this.doorList[2] = new Door(new PVector(width / 2, height), "DOWN");
    if ((this.doors & 8) != 0) this.doorList[3] = new Door(new PVector(0, height / 2), "LEFT");
  }

  /** Metodo que dibuja a la puerta */
  public void display() {
    noStroke();
    fill(170);
    rect(-1, -1, ancho, alto);
    for (Door door : this.doorList) {
      if (door != null) door.display();
    }
  }

  /** Metodo que devuelve si hay puertas en la habitacion*/
  public boolean hasDoors() {
    for (Door door : this.doorList) {
      if (door != null) return true; // verifica si el objeto door no es null.
    }
    println("no hay puertas!! estas encerrado!! >:3");
    return false;
  }
  
  /** Metodo que verifica y actualiza el estado de las puertas*/
  public void updateDoors(){
    if(!hayEnemigos()){
      stateDoors(true);
    } else {
    stateDoors(false);
    }
  }
  
  /* Devuelve si hay enemigos */
  public boolean hayEnemigos(){
    if(towers.size() == 0 && followers.size() == 0 &&subBosses.size() == 0){
      return false;
    }
    
    text("todos: " +getAllEnemies().size()  ,40,60);
    return true;
  }
  
  /** Metodo que cierra o abre las puertas */
  public void stateDoors(boolean state) {
    for (Door door : this.doorList) {
      if (door != null) {
        door.setIsOpen(state);
      }
    }
  }
   public void addTower(Tower tower) {
    this.towers.add(tower);
  }

  public void addFollower(Follower follower) {
    this.followers.add(follower);
  }

  public void removeEnemy(Enemy enemy) {
  if (enemy instanceof Tower) {
    towers.remove(enemy);
  } if (enemy instanceof Follower) {
    followers.remove(enemy);
  }
  else if (enemy instanceof SubBoss) {
    subBosses.remove(enemy);
  }
  }
  public void addSubBoss(SubBoss subBoss) {
    this.subBosses.add(subBoss);
  }
   public ArrayList<SubBoss> getSubBosses() {
    return this.subBosses;
  }

  public ArrayList<Tower> getTowers() {
    return this.towers;
  }

  public ArrayList<Follower> getFollowers() {
    return this.followers;
  }

    public ArrayList<Enemy> getAllEnemies() {
    ArrayList<Enemy> todosLosEnemigos = new ArrayList<Enemy>();
    todosLosEnemigos.addAll(towers);
    todosLosEnemigos.addAll(followers);
    todosLosEnemigos.addAll(subBosses);
    return todosLosEnemigos;
  }
}
