class RoomRenderer {
  private Dungeon dungeon;
  private GestorEnemigos gestorEnemigos;
  private GestorBullets bullets;
  private RoomVisualRegistry roomVisuals;
  private RoomEnemySpawner spawner;
  
  CollectibleFactory factory = new CollectibleFactory();

  public RoomRenderer(Dungeon dungeon, GestorBullets bullets, RoomVisualRegistry roomVisuals) {
    this.dungeon = dungeon;
    this.gestorEnemigos = new GestorEnemigos() ;
    this.spawner = new RoomEnemySpawner(dungeon.getRows() * dungeon.getCols());
    this.bullets = bullets;
    this.roomVisuals = roomVisuals;
  }

  public void render(Player player, CaminanteAleatorio walker) {
    Room roomActual = dungeon.getRoom(player.getCol(), player.getRow());
    if (roomActual == null) return;
    
    roomVisuals.get(roomActual.getType()).render();
    roomActual.checkColectable(player);
    for (Door door : roomActual.getAllDoors()) {
      door.display();
    }
    roomActual.updateDoors(gestorEnemigos.hayEnemigos());
    
    PVector startPos = walker.getStartPos();
    PVector subPos = walker.getSubBossPos();
    Room roomInicial = dungeon.getRoom((int)startPos.x, (int)startPos.y);
    Room subRoom = dungeon.getRoom((int)subPos.x, (int)subPos.y);
    subRoom.setType(RoomType.SUBBOSS);
    spawner.enemigosGenerados[roomInicial.getNameRoom()] = true;


    if (roomActual == roomInicial) {
      mostrarTutorial();
    }
    
    if (
      roomActual.getType() == RoomType.SUBBOSS &&
      !gestorEnemigos.hayEnemigos() &&
      !roomActual.hasLootSpawned()
    ) {
      roomActual.markLootSpawned();
      Collectible drop = factory.randomTreasure(
        roomActual.getCenterPosition()
      );
    
      if (drop != null) {
        roomActual.addCollectible(drop);
      }
    
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
          //Genera cuando el player toca la puerta
          spawner.spawnForRoom(nextRoom, gestorEnemigos);
          bullets.clearBullets();
      }
    }
    
    // --- Logica BossRoom ---
    if (roomActual instanceof BossRoom) {
        BossRoom br = (BossRoom) roomActual;
        if (gestorEnemigos.hayEnemigos() && !br.hasVictoryDoor()) {
            br.spawnVictoryDoor();
        }

        Door doorr = player.checkCollision(roomActual);
        if (doorr instanceof VictoryDoor) {
            changeState(victoria);
        }
    }
    
    bullets.update(gestorEnemigos, player);
    bullets.dibujarBalas();
    // Actualizar enemigos
    gestorEnemigos.actualizar(player, bullets);
    
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
