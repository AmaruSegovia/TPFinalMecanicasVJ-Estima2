/** Clase que gestiona la aparicion y comportamiento de los enemigos */
class GestorEnemigos {
  /** Representan a los enemigos */
  private ArrayList<Tower> towers;
  private ArrayList<Follower> followers;
  private ArrayList<SubBoss> subBosses;
  private ArrayList<Boss> boss;
  /** Representa la maxima cantidad de tipos de enemigo x room */
  private int maxEnemigos = 2;

  /* -- CONSTRUCTOR -- */
  public GestorEnemigos() {
    this.towers = new ArrayList<Tower>();
    this.followers = new ArrayList<Follower>();
    this.subBosses = new ArrayList<SubBoss>();
  }
  /* Inicializa a todos los enemigos */
  public void inicializarEnemigos(Room room){
    inicializarTowers(room);
    inicializarFollowers(room);
    inicializarSubBosses(room);
  }

  /** Inicializa a enemigos por tipo */
  public void inicializarTowers(Room room) {
    for (int i = 0; i < maxEnemigos; i++) {
      float x = random(50, width - 50);
      float y = random(50, height - 50);
      addTower(new PVector(x, y), room);
    }
  }
  public void inicializarFollowers(Room room) {
    for (int i = 0; i < maxEnemigos; i++) {
      float x = random(50, width - 50);
      float y = random(50, height - 50);
      addFollower(new PVector(x, y), room);
    }
  }
  public void inicializarSubBosses(Room room) {
    for (int i = 0; i < 1; i++) {
      float x = random(50, width - 50);
      float y = random(50, height - 50);
      addSubBoss(new PVector(x, y), room);
    }
  }
  public void inicializarBoss(Room room){
    Boss boss = new Boss(new PVector(width/2, 70));
    room.addBoss(boss);
  }

  /** Agrega enemigos segun su tipo*/
  public void addTower(PVector posicion, Room room) {
    Tower tower = new Tower(posicion);
    towers.add(tower);
    room.addTower(tower);
  }
  public void addFollower(PVector posicion, Room room) {
    Follower follower = new Follower(posicion);
    followers.add(follower);
    room.addFollower(follower); 
  }
  public void addSubBoss(PVector posicion, Room room) {
    SubBoss subBoss = new SubBoss(posicion);
    subBosses.add(subBoss);
    room.addSubBoss(subBoss);
  }
  
  /* Actualiza el comportamiento de los enemigos */
  public void actualizar(Room roomActual) {
    for (Tower tower : roomActual.getTowers()) {
      tower.display();
      tower.detectar(jugador);
    }

    for (Follower follower : roomActual.getFollowers()) {
      follower.display();
      follower.seguirJugador(jugador);
      follower.evitarColisiones(roomActual.getFollowers());
    }
    for (SubBoss subBoss : roomActual.getSubBosses()) {
      subBoss.display();
      subBoss.actualizarPosicion(jugador.posicion);
      subBoss.creacionEliminacionBombas(jugador);
    }
      for (Boss boss : roomActual.getBosses()) {
        boss.display();
        boss.mover();
        boss.detectarPlayer(jugador);
  
      }
    
  }
}
