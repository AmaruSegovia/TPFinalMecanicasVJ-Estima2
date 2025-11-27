/** Clase que gestiona la aparicion y comportamiento de los enemigos */
class GestorEnemigos {
  /** Representa la maxima cantidad de tipos de enemigo x room */
  private int maxEnemigos = 2;
  /** Representa los enemigos*/
  private ArrayList<Enemy> enemies;
  
  /** Verifica si los enemigos han sido generados en X room */
  private boolean[] enemigosGenerados;

  /* -- CONSTRUCTOR -- */
  public GestorEnemigos(int tamanio) {
    this.enemies = new ArrayList<Enemy>();
    this.enemigosGenerados = new boolean[tamanio]; // Por defecto se inicializan en falso
    this.enemigosGenerados[0] = true;
  }
  /* Inicializa a todos los enemigos */
  public void inicializarEnemigos(){
    //inicializarTowers();
    //inicializarFollowers();
    //inicializarSubBosses();
    inicializarBoss();
  }
  
  public void createEnemies (int nameRoom) {
    //removeEnemies();
    // Verificar si los enemigos ya han sido generados para esta habitación
    if (this.enemigosGenerados[nameRoom]) {
      return; // Salir si ya han sido generados
    }
    inicializarEnemigos();
    this.enemigosGenerados[nameRoom] = true;
  }

  /** Inicializa a enemigos por tipo */
  public void inicializarTowers() {
    for (int i = 0; i < maxEnemigos; i++) {
      PVector pos = posicionAleatoria();
      addEnemy(new Tower(pos));
    }
  }
  public void inicializarFollowers() {
    for (int i = 0; i < maxEnemigos; i++) {
      PVector pos = posicionAleatoria();
      addEnemy(new Follower(pos));
    }
  }
  public void inicializarSubBosses() {
    PVector pos = posicionAleatoria();
    addEnemy(new SubBoss(pos));
  }
  public void inicializarBoss(){
    addEnemy(new Boss(new PVector(width/2, 70)));
  }
  
  private PVector posicionAleatoria() {
    float x = random(50, width - 50);
    float y = random(50, height - 50);
    return new PVector(x, y);
  }
  
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
  
  /**Imprime cantidad de enemigos y puertas, depuracion **/
  public void debugInfo() {
    println(" | Enemies: " + getAllEnemies().size());
  }
  
  /* Getters enemigos*/
  public ArrayList<Enemy> getAllEnemies() { return this.enemies; }
}
