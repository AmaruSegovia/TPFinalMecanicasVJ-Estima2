/** Clase que representa las habitaciones de la dungeon */
class Room extends GameObject {
  /** Representa las posiciones de las puertas en binario */
  private int doors;
  /** Representa la lista de puertas que tiene la habitacion*/
  private Door[] doorList;
<<<<<<< Updated upstream
=======
  /*representa los enemigos*/
  private ArrayList<Tower> towers;
  private ArrayList<Follower> followers;
>>>>>>> Stashed changes

  /* -- CONSTRUCTORES -- */
  /** Constructor por defecto */
  public Room() {
  }
  /** Constructor parametrizado */
  public Room(int doors, int ancho, int alto, PVector posicion) {
    super(posicion, ancho, alto);
    this.doors = doors;
    this.doorList = new Door[4];
<<<<<<< Updated upstream
=======
    this.towers=new ArrayList<Tower>();
    this.followers = new ArrayList<Follower>();
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
   public void addTower(Tower tower) {
    this.towers.add(tower);
  }
  
  public void addFollower(Follower follower) {
    this.followers.add(follower);
  }
  
  public void removeEnemy(Enemy enemy) {
  if (enemy instanceof Tower) {
    towers.remove(enemy);
  } else if (enemy instanceof Follower) {
    followers.remove(enemy);
  }
>>>>>>> Stashed changes
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
    return todosLosEnemigos;
  }
  
}
