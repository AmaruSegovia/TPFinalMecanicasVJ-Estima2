/** Clase que gestiona los enemigos vivos */
class GestorEnemigos {
  /** Representa a los enemigos x room */
  private ArrayList<Enemy> enemies = new ArrayList<>();

  /* -- CONSTRUCTOR -- */
  public GestorEnemigos() {
  }
  
  // -----------------------------
  
  public void spawn(ArrayList<Enemy> nuevos) {
    enemies.clear();
    enemies.addAll(nuevos);
  }

  public void update(Player jugador, GestorBullets gestorBalas) {
    for (Enemy e : enemies) {
      e.update(jugador, this);

      if (e instanceof IShooter) {
        ((IShooter)e).shoot(jugador, gestorBalas);
      }

      e.display();
    }

    enemies.removeIf(Enemy::isDead);
  }

  public void clear() {
    enemies.clear();
  }

  public ArrayList<Enemy> getAllEnemies() {
    return enemies;
  }
  
  // ----------------------------
  
  /* Actualiza el comportamiento de los enemigos */
  public void actualizar(Player jugador, GestorBullets gestorBalas) {
    ArrayList<Enemy> enemigos = getAllEnemies();

    for (Enemy e : enemigos) {
      e.update(jugador, this);
      // Solo disparan los que implementan IShooter
      if (e instanceof IShooter) {
        ((IShooter)e).shoot(jugador, gestorBalas);
      }
      e.display();
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
