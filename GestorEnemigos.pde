/** Clase que gestiona la aparicion y comportamiento de los enemigos */
class GestorEnemigos {
  /** Representa la maxima cantidad de tipos de enemigo x room */
  private int maxEnemigos = 2;
  /** Representa los enemigos*/
  private ArrayList<Enemy> enemies;
  /** Verifica si los enemigos han sido generados en X room */
  private boolean[] enemigosGenerados;
  
  /** Array de patrones */
  private ArrayList<PatronEnemigo> patrones;

  /* -- CONSTRUCTOR -- */
  public GestorEnemigos(int tamanio) {
    this.enemies = new ArrayList<Enemy>();
    this.enemigosGenerados = new boolean[tamanio]; // Por defecto se inicializan en falso
    this.enemigosGenerados[0] = true;
    this.patrones = new ArrayList<>();
    inicializarPatrones();
  }
  /* Inicializa a todos los enemigos */
  public void inicializarEnemigos(){
    //inicializarTowers();
    //inicializarFollowers();
    //inicializarSubBosses();
    inicializarBoss();
  }
  
  public void createEnemies (Room room) {
    removeEnemies();
    // Verificar si los enemigos ya han sido generados para esta habitacion
    if (this.enemigosGenerados[room.getNameRoom()]) {
      return; // Salir si ya han sido generados
    }
    
    if (room.getType() == RoomType.BOSS) {
    inicializarBoss();
    room.stateDoors(false); // cerrar puertas al entrar
    } else if (room.getType() == RoomType.SUBBOSS) {
      inicializarSubBosses();
    } else if (room.getType() == RoomType.TREASURE) {
      // no enemigos, solo cofres
    } else {
      generarFormacion(room.getNameRoom());
    }
    
    this.enemigosGenerados[room.getNameRoom()] = true;
  }
  
  /** ----------- FORMACION SEGUN PATRONES  -------------- **/
  public void generarFormacion(int nameRoom) {
    // Escoje un patron de la lista de patrones
    PatronEnemigo patronSeleccionado = this.patrones.get((int) random(this.patrones.size()));

    for (int i = 0; i < patronSeleccionado.getPosiciones().size(); i++) {
      PVector pos = patronSeleccionado.getPosiciones().get(i).copy();
      String tipo = patronSeleccionado.getTipos().get(i);

      Enemy e = null;
      switch (tipo) {
        case "Tower":    e = new Tower(pos); break;
        case "Follower": e = new Follower(pos); break;
        case "SubBoss":  e = new SubBoss(pos); break;
      }
      if (e != null) enemies.add(e);
    }

    // Marcar la habitacion como generada, para que no se genere cuando vuelva a pasar por alli
    this.enemigosGenerados[nameRoom] = true;
  }
  
  /** Metodo que inicializa los patrones de los enemigos */
  private void inicializarPatrones() {
    // Patrón 1: 3 enemigos alineados horizontalmente
    PatronEnemigo patron1 = new PatronEnemigo();
    addPosiciones(patron1, 3, height/2, "Tower");
    patrones.add(patron1);

    // Patron 2: 8 enemigos alineados horizontalmente arriba y abajo
    PatronEnemigo patron2 = new PatronEnemigo();
    addPosiciones(patron2, 4, height/3, "Follower");
    addPosiciones(patron2, 4, height - height/3, "Follower");
    patrones.add(patron2);
    
    // Patron 3: Enemigos en forma de triangulo
    PatronEnemigo patron3 = new PatronEnemigo();
    addPosicionUnica(patron3, width/2, height/3, "Tower");
    addPosiciones(patron3, 2, height/2, "Tower");
    addPosiciones(patron3, 3, height - height/3, "Tower");
    patrones.add(patron3);
    
    PatronEnemigo patron4 = new PatronEnemigo();
    patron4.addPosicion(new PVector(width/2 - 50, height/2), "Tower");
    patron4.addPosicion(new PVector(width/2 + 50, height/2), "Tower");
    patron4.addPosicion(new PVector(50, 50), "Follower");
    patron4.addPosicion(new PVector(width - 50, 50), "Follower");
    patron4.addPosicion(new PVector(50, height - 50), "Follower");
    patron4.addPosicion(new PVector(width - 50, height - 50), "Follower");
    patrones.add(patron4);
    
    // Se pueden agregar mas patrones 
  }
   /** Metodo auxiliar para agregar una posicion unica a un patron */
  private void addPosicionUnica(PatronEnemigo patron, float x, float y, String tipo) {
    patron.addPosicion(new PVector(x, y), tipo);
  }

  /** Metodo auxiliar para agregar posiciones a un patron */
  private void addPosiciones(PatronEnemigo patron, int cantidadEnemies, float y, String tipo) {
    for (int i = 0; i < cantidadEnemies; i++) {
      float x = (i + 1) * width / (cantidadEnemies + 1);
      patron.addPosicion(new PVector(x, y), tipo);
    }
  }
  /**  ------  Inicializa a enemigos por tipo ------ */
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
    for (int i = 0; i < maxEnemigos; i++) {
      PVector pos = posicionAleatoria();
      addEnemy(new SubBoss(pos));
    }
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
