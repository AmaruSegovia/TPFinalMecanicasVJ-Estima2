class GestorEnemigos {
  private ArrayList<Enemy> enemigos;
  ///private Player jugador;
  private int maxEnemigos = 2;

  public GestorEnemigos() {
   // this.jugador = jugador;
    this.enemigos = new ArrayList<Enemy>();
  }

  public void inicializarTorretas(Room room) {
    for (int i = 0; i < maxEnemigos; i++) {
      float x = random(50, width - 50);
      float y = random(50, height - 50);
      addEnemy(new PVector(x, y), room);
    }
  }

  public void addEnemy(PVector posicion, Room room) {
    Enemy enemy = new Enemy(posicion);
    enemigos.add(enemy);
    room.addEnemy(enemy); // Añadir la torreta a la habitación
  }

  public void actualizar(Room roomActual) {
    for (Enemy enemy : roomActual.getEnemies()) {
      enemy.display();
    }
  }
}
