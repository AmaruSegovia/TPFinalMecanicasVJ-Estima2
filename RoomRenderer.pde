class RoomRenderer {
  private Dungeon dungeon;
  private GestorEnemigos gestorEnemigos;
  private GestorBullets bullets;

  public RoomRenderer(Dungeon dungeon, GestorBullets bullets) {
    this.dungeon = dungeon;
    this.gestorEnemigos = new GestorEnemigos() ;
    this.bullets = bullets;
  }

  public void render(Player player) {
    Room roomActual = dungeon.getRoom(player.getCol(), player.getRow());
    if (roomActual == null) return;

    roomActual.display();
    Room roomInicial = dungeon.getRoom(0,0);
    // Inicializar enemigos solo si la Room está vacía
    if (roomActual != roomInicial && roomActual.getAllEnemies().isEmpty()) {
      gestorEnemigos.inicializarEnemigos(roomActual);
    }

    if (roomActual == roomInicial) {
      mostrarTutorial();
    }
    
    Door door = player.checkCollision(roomActual);
    if (door != null) {
      int newCol = player.getCol();
      int newRow = player.getRow();
    
      switch (door.getDirection()) {
        case UP:    newRow--; break;
        case DOWN:  newRow++; break;
        case LEFT:  newCol--; break;
        case RIGHT: newCol++; break;
      }
    
      Room nextRoom = dungeon.getRoom(newCol, newRow);
      if (nextRoom != null) {
        // Buscando la puerta opuesta
        Door entryDoor = nextRoom.getDoor(door.getDirection().getOpposite());
        PVector entryPos;
        // Si existe la puerta usar su posicion
        if (entryDoor != null) {
          entryPos = entryDoor.getEntryPosition();
        } else {
          // Si no tiene puertas, colocar al jugador en el centro
          entryPos = new PVector(width/2, height/2);
        }
          player.updatePosition(newCol, newRow, entryPos);
      }
    }
    
    bullets.update(roomActual, player);
    bullets.dibujarBalas();
    // Actualizar enemigos
    gestorEnemigos.actualizar(roomActual, player, bullets);
  }

  private void mostrarTutorial() {
    fill(#ccffff);
    textSize(48);
    text("Cómo Jugar", width/2, height/8);
    textSize(36);
    text("Caminar", width/4.8, height/1.5);
    text("Disparar", width/1.27, height/1.5);
    imageMode(CENTER);
    image(loadImage("wasd.png"), width/4.8, height/1.8, 120, 80);        
    image(loadImage("ijkl.png"), width/1.27, height/1.8, 120, 80);
  }
  
  public GestorBullets getBullets() {
    return bullets;
  }

}
