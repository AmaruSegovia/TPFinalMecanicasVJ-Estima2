class GestorEnemigos {
  private ArrayList<Tower> towers;
  private int maxEnemigos = 2;
  private ArrayList<Follower> followers;
  
  private ArrayList<SubBoss> subBosses;
 
  public GestorEnemigos() {
     this.towers = new ArrayList<Tower>();
    this.followers = new ArrayList<Follower>();
    this.subBosses = new ArrayList<SubBoss>();
  }

  public void inicializarEnemigos(Room room) {
     for (int i = 0; i < maxEnemigos; i++) {
      float x = random(50, width - 50);
      float y = random(50, height - 50);
      addTower(new PVector(x, y), room);
    }

    for (int i = 0; i < maxEnemigos; i++) {
      float x = random(50, width - 50);
      float y = random(50, height - 50);
      addFollower(new PVector(x, y), room);
    }
    for(int i = 0; i < 1; i++){
      float x = random(50, width - 50);
      float y = random(50, height - 50);
      addSubBoss(new PVector(x, y), room);
    }
  }

  public void addTower(PVector posicion, Room room) {
    Tower tower = new Tower(posicion);
    towers.add(tower);
    room.addTower(tower); // Asegúrate de que la habitación tenga un método para agregar enemigos
  }

  public void addFollower(PVector posicion, Room room) {
    Follower follower = new Follower(posicion);
    followers.add(follower);
    room.addFollower(follower); // Asegúrate de que la habitación tenga un método para agregar enemigos
  }
  
  public void addSubBoss(PVector posicion, Room room) {
    SubBoss subBoss = new SubBoss(posicion);
    subBosses.add(subBoss);
    room.addSubBoss(subBoss); // Asegúrate de que la habitación tenga un método para agregar enemigos
  }
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
    for(SubBoss subBoss : roomActual.getSubBosses()){
      subBoss.display();
      subBoss.actualizarPosicion(jugador.posicion);
      subBoss.creacionEliminacionBombas(jugador);
    }
  }
}
