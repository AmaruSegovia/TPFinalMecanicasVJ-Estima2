/** Decide los enemigos aparecen segun el tipo de Room */
class RoomEnemySpawner {
  private boolean[] enemigosGenerados;
  private ArrayList<PatronEnemigo> patrones;
  private int maxEnemigos = (int)random(1,3);

  public RoomEnemySpawner(int totalRooms) {
    enemigosGenerados = new boolean[totalRooms];
    patrones = new ArrayList<>();
    inicializarPatrones();
  }

  public void spawnForRoom(Room room, GestorEnemigos gestor) {
    // Si es la sala inicial o ya se generaron enemigos, no hacer nada
    if (room.isStart() || this.enemigosGenerados[room.getNameRoom()]) {
      enemigosGenerados[room.getNameRoom()] = true; 
      return; 
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
    PVector centro = new PVector(width/2, height/2);

    // Patron 1: El Escuadrón V
    PatronEnemigo patron1 = new PatronEnemigo();
    patron1.addPosicion(new PVector(width/2, height/2), "Tower");
    patron1.addPosicion(new PVector(width/3, height/2), "Follower");
    patron1.addPosicion(new PVector(2*width/3, height/2), "Follower");
    patrones.add(patron1);

    // Patron 2: Círculo de Acecho
    PatronEnemigo patron2 = new PatronEnemigo();
    patron2.addCirculo(centro, 150, 6, "Follower");
    patrones.add(patron2);
    
    // Patron 3: La Cruz Defensiva
    PatronEnemigo patron3 = new PatronEnemigo();
    patron3.addCruz(centro, 120, "Tower");
    patrones.add(patron3);
    
    // Patron 4: Doble Fila
    PatronEnemigo patron4 = new PatronEnemigo();
    patron4.addFila(height/2, 2, "Follower");
    patron4.addFila(height/2, 3, "Tower");
    patrones.add(patron4);

    // Patron 5: Las 4 Esquinas
    PatronEnemigo patron5 = new PatronEnemigo();
    patron5.addPosicion(new PVector(100, 100), "Tower");
    patron5.addPosicion(new PVector(width-100, 100), "Tower");
    patron5.addPosicion(new PVector(100, height-100), "Tower");
    patron5.addPosicion(new PVector(width-100, height-100), "Tower");
    patron5.addPosicion(centro, "Follower");
    patrones.add(patron5);

    // Patron 6: La Muralla
    PatronEnemigo patron6 = new PatronEnemigo();
    patron6.addColumna(width/4, 3, "Tower");
    patron6.addColumna(3*width/4, 2, "Follower");
    patrones.add(patron6);

    // Patron 7: El Diamante Central
    PatronEnemigo patron7 = new PatronEnemigo();
    patron7.addX(centro, 100, "Tower");
    patron7.addCirculo(centro, 200, 4, "Follower");
    patrones.add(patron7);

    // Patron 8: Pasillo
    PatronEnemigo patron8 = new PatronEnemigo();
    patron8.addColumna(width/3, 4, "Follower");
    patron8.addColumna(2*width/3, 4, "Follower");
    patrones.add(patron8);

    // Patron 9: Emboscada Total
    PatronEnemigo patron9 = new PatronEnemigo();
    patron9.addPosicion(centro, "Tower");
    patron9.addCirculo(centro, 180, 8, "Follower");
    patrones.add(patron9);
  }

  private PVector posicionAleatoria() {
    return new PVector(
      random(50, width - 50),
      random(50, height - 50)
    );
  }
}
