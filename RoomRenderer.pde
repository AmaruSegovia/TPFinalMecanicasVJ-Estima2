class RoomRenderer {
  private Dungeon dungeon;
  private GestorEnemigos enemies;
  private GestorBullets bullets;

  public RoomRenderer(Dungeon dungeon, GestorEnemigos enemies, GestorBullets bullets) {
    this.dungeon = dungeon;
    this.enemies = enemies;
    this.bullets = bullets;
  }

  public void render(Player player) {
    Room roomActual = dungeon.getRoom(player.getCol(), player.getRow());
    if (roomActual == null) return;

    roomActual.display();

    if (roomActual == dungeon.getRoom(0,0)) {
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
    
    bullets.update(roomActual, jugador);
    bullets.dibujarBalas();
    //enemies.actualizar(roomActual);
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
