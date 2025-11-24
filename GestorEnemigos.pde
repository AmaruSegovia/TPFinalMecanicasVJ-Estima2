/** Clase que gestiona la aparicion y comportamiento de los enemigos */
class GestorEnemigos {
  /** Representa la maxima cantidad de tipos de enemigo x room */
  private int maxEnemigos = 2;

  /* -- CONSTRUCTOR -- */
  public GestorEnemigos() {
  }
  /* Inicializa a todos los enemigos */
  public void inicializarEnemigos(Room room){
    //inicializarTowers(room);
    //inicializarFollowers(room);
    //inicializarSubBosses(room);
    inicializarBoss(room);
  }

  /** Inicializa a enemigos por tipo */
  public void inicializarTowers(Room room) {
    for (int i = 0; i < maxEnemigos; i++) {
      PVector pos = posicionAleatoria();
      room.addEnemy(new Tower(pos));
    }
  }
  public void inicializarFollowers(Room room) {
    for (int i = 0; i < maxEnemigos; i++) {
      PVector pos = posicionAleatoria();
      room.addEnemy(new Follower(pos));
    }
  }
  public void inicializarSubBosses(Room room) {
    PVector pos = posicionAleatoria();
    room.addEnemy(new SubBoss(pos));
  }
  public void inicializarBoss(Room room){
    room.addEnemy(new Boss(new PVector(width/2, 70)));
  }
  
  private PVector posicionAleatoria() {
    float x = random(50, width - 50);
    float y = random(50, height - 50);
    return new PVector(x, y);
  }
  
  /* Actualiza el comportamiento de los enemigos */
  public void actualizar(Room room, Player jugador, GestorBullets gestorBalas) {
    ArrayList<Enemy> enemigos = room.getAllEnemies();

    for (Enemy e : enemigos) {
      e.update(jugador, room);
      // Solo disparan los que implementan IShooter
      if (e instanceof IShooter) {
        ((IShooter)e).shoot(jugador, gestorBalas);
      }
      e.display();
    }

    // Eliminar los que murieron
    enemigos.removeIf(Enemy::isDead);
  }
}
