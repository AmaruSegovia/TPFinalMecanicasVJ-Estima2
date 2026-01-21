/** Clase que gestiona los enemigos vivos */
class GestorEnemigos {
  /** Representa a los enemigos x room */
  private ArrayList<Enemy> enemies = new ArrayList<>();
  private LifeBar enemyBar = new LifeBar(40, 5, 30);
  
   private boolean roomActive = false;
  private int roomEnterTime = 0;
  private int activationDelay = 1000; // 1 segundo

  /* -- CONSTRUCTOR -- */
  public GestorEnemigos() {
  }
  
  // -----------------------------
  
  public void spawn(ArrayList<Enemy> nuevos) {
  enemies.clear();
  enemies.addAll(nuevos);

  roomActive = false;
  roomEnterTime = millis();
}

  public void clear() {
    enemies.clear();
  }
  
  private void updateRoomState() {
    if (!roomActive && millis() - roomEnterTime >= activationDelay) {
      roomActive = true;
    }
  }


  public ArrayList<Enemy> getAllEnemies() {
    return enemies;
  }
  
  // ----------------------------
  
  /* Actualiza el comportamiento de los enemigos */
  public void actualizar(Player jugador, GestorBullets gestorBalas) {
    ArrayList<Enemy> enemigos = getAllEnemies();
    updateRoomState();

    for (Enemy e : enemigos) {
      if (roomActive) {
      e.update(jugador, this);

      if (e instanceof IShooter) {
        ((IShooter)e).shoot(jugador, gestorBalas);
      }
    } else {
      // enemigos congelados
      e.updateHitEffect(); // opcional: solo animaciones
    }
    
      e.display();
      if (jugador.canSeeEnemyLife() && !(e instanceof Boss))
        enemyBar.draw( e.getPosicion(), e.getLives(), e.getMaxLives());
    }

    // Eliminar los que murieron
    enemigos.removeIf(Enemy::isDead);
  }
  
  /** Devuelve si hay enemigos */
  public boolean hayEnemigos() {
    return !getAllEnemies().isEmpty();
  }
  
  /** Metodos que agregan a los enemigos */
  public void addEnemy(Enemy e) {
    enemies.add(e);
  }
  
  /** Metodo que remueve a los enemigos */
  public void removeEnemy(Enemy e) {
    enemies.remove(e);
  }
  
  public void removeEnemies() {
    this.enemies.clear(); // Eliminar los enemigos de la lista
  }
}
