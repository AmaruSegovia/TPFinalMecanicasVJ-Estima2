class GestorEnemigos {
  private ArrayList<Enemy> enemigos;
  private int maxEnemigos = 2;
  private ArrayList<EnemyFollower> enemyFollowers;
  
  private ArrayList<SubBoss> subBosses;
 
  public GestorEnemigos() {
    this.enemigos = new ArrayList<Enemy>();
    this.enemyFollowers = new ArrayList<EnemyFollower>();
    this.subBosses = new ArrayList<SubBoss>();
  }

  public void inicializarTorretas(Room room) {
    for (int i = 0; i < maxEnemigos; i++) {
      float x = random(50, width - 50);
      float y = random(50, height - 50);
      addEnemy(new PVector(x, y), room);
    }
    
    for (int i = 0; i < maxEnemigos; i++) {
      float x = random(50, width - 50);
      float y = random(50, height - 50);
      addFollowerEnemy(new PVector(x, y), room);
    }
    for(int i = 0; i < 1; i++){
      float x = random(50, width - 50);
      float y = random(50, height - 50);
      addSubBoss(new PVector(x, y), room);
    }
  }

  public void addEnemy(PVector posicion, Room room) {
    Enemy enemy = new Enemy(posicion);
    enemigos.add(enemy);
    room.addEnemy(enemy); // Asegúrate de que la habitación tenga un método para agregar enemigos
  }
  
  public void addFollowerEnemy(PVector posicion, Room room) {
    EnemyFollower enemyFollower = new EnemyFollower(posicion);
    enemyFollowers.add(enemyFollower);
    room.addEnemyFollower(enemyFollower); // Asegúrate de que la habitación tenga un método para agregar enemigos
  }
  
  public void addSubBoss(PVector posicion, Room room) {
    SubBoss subBoss = new SubBoss(posicion);
    subBosses.add(subBoss);
    room.addSubBoss(subBoss); // Asegúrate de que la habitación tenga un método para agregar enemigos
  }
  public void actualizar(Room roomActual) {
    for (Enemy enemy : roomActual.getEnemies()) {
      enemy.display();
      enemy.detectar(jugador);
    }
    
    for (EnemyFollower enemyFollower : roomActual.getEnemyFollowers()) {
      enemyFollower.display();
      enemyFollower.seguirJugador(jugador);
      enemyFollower.evitarColisiones(roomActual.getEnemyFollowers());
    }
    for(SubBoss subBoss : roomActual.getSubBosses()){
      subBoss.display();
      subBoss.actualizarPosicion(jugador.posicion);
      subBoss.creacionEliminacionBombas(jugador);
    }
  }
}
