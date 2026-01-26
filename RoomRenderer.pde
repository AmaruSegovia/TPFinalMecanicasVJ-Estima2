class RoomRenderer {
  private Dungeon dungeon;
  private GestorEnemigos gestorEnemigos;
  private GestorBullets bullets;
  private RoomVisualRegistry roomVisuals;
  private RoomEnemySpawner spawner;
  
  private CollectibleFactory factory = new CollectibleFactory();
  

  public RoomRenderer(Dungeon dungeon, GestorBullets bullets, RoomVisualRegistry roomVisuals) {
    this.dungeon = dungeon;
    this.gestorEnemigos = new GestorEnemigos() ;
    this.spawner = new RoomEnemySpawner(dungeon.getRows() * dungeon.getCols());
    this.bullets = bullets;
    this.roomVisuals = roomVisuals;
    
  }

  public void render(Player player) {
    Room roomActual = dungeon.getRoom(player.getCol(), player.getRow());
    if (roomActual == null) return;
    
    roomVisuals.get(roomActual.getType()).render();
    roomActual.checkColectable(player);
    for (Door door : roomActual.getAllDoors()) {
      door.display();
    }
    roomActual.updateDoors(gestorEnemigos.hayEnemigos());
    
    // Polimorfismo: Cada tipo de sala ejecuta su propia lógica e interfaz extra
    roomActual.handleRoomLogic(gestorEnemigos, player);
    roomActual.renderRoomUI(this);
    
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
          //Genera cuando el player toca la puerta
          spawner.spawnForRoom(nextRoom, gestorEnemigos);
          bullets.clearBullets();
      }
    }
    
    bullets.update(gestorEnemigos, player);
    bullets.dibujarBalas();
    gestorEnemigos.actualizar(player, bullets);
  }

  public GestorBullets getBullets() {
    return bullets;
  }
}
