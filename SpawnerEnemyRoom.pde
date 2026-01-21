/** Decide los enemigos aparecen segun el tipo de Room */
class RoomEnemySpawner {
  private boolean[] enemigosGenerados;
  private ArrayList<PatronEnemigo> patrones;
  private int maxEnemigos = (int)random(1,3);

  public RoomEnemySpawner(int totalRooms) {
    enemigosGenerados = new boolean[totalRooms];
    enemigosGenerados[0] = true;
    patrones = new ArrayList<>();
    inicializarPatrones();
  }

  public void spawnForRoom(Room room, GestorEnemigos gestor) {
    
    // Verificar si los enemigos ya han sido generados para esta habitacion
    if (this.enemigosGenerados[room.getNameRoom()]) {
      return; // Salir si ya han sido generados
    }

    ArrayList<Enemy> nuevos = new ArrayList<>();

    switch (room.getType()) {

      case BOSS:
        nuevos.add(new Boss(new PVector(width/2, 70)));
        room.stateDoors(false);
        break;

      case SUBBOSS:
        for (int i = 0; i < maxEnemigos; i++) {
          nuevos.add(new SubBoss(posicionAleatoria()));
        }
        room.stateDoors(false);
        break;

      case TREASURE:
        // sin enemigos
        break;

      default:
        nuevos.addAll(generarDesdePatron());
        room.stateDoors(false);
        break;
    }

    gestor.spawn(nuevos);
    // Marcar la habitacion como generada, para que no se genere cuando vuelva a pasar por alli
    enemigosGenerados[room.getNameRoom()] = true;
  }

/** ----------- FORMACION SEGUN PATRONES  -------------- **/
  private ArrayList<Enemy> generarDesdePatron() {
    ArrayList<Enemy> enemigos = new ArrayList<>();
    // Escoje un patron de la lista de patrones
    PatronEnemigo patron = patrones.get((int) random(patrones.size()));

    for (int i = 0; i < patron.getPosiciones().size(); i++) {

      PVector pos = patron.getPosiciones().get(i).copy();
      String tipo = patron.getTipos().get(i);
      Enemy e = null;

      switch (tipo) {
        case "Tower":    e = new Tower(pos); break;
        case "Follower": e = new Follower(pos); break;
        case "SubBoss":  e = new SubBoss(pos); break;
      }
      if (e != null) enemigos.add(e);
    }

    return enemigos; // devuelve la lista de enemigos
  }
  
  /** Metodo que inicializa los patrones de los enemigos */
  private void inicializarPatrones() {
    // Patron 1: 3 enemigos alineados horizontalmente
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

  private PVector posicionAleatoria() {
    return new PVector(
      random(50, width - 50),
      random(50, height - 50)
    );
  }
}
