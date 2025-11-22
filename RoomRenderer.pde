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
    roomActual.updateDoors();

    if (roomActual == dungeon.getRoom(0,0)) {
      mostrarTutorial();
    }

    player.checkCollisions(roomActual);
    bullets.updateBullets(roomActual);
    bullets.dibujarBalas();
    enemies.actualizar(roomActual);
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
}
