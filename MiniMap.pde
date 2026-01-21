enum DungeonDir {
  UP   (0, -1, 1),
  RIGHT(1,  0, 2),
  DOWN (0,  1, 4),
  LEFT (-1, 0, 8);

  final int dx, dy, bit;

  DungeonDir(int dx, int dy, int bit) {
    this.dx = dx;
    this.dy = dy;
    this.bit = bit;
  }

  boolean isOpen(int val) {
    return (val & bit) != 0;
  }
}

class MiniMap {
  private Dungeon dungeon;

  // Tamanio base
  private int baseCellSize = 25;
  private int spaceCell;
  private int cellSize;

  // Escalas
  private float normalScale = 1.0;
  private float expandedScale = 2.5;
  private float scale;

  // Estado
  private boolean[][] visited;
  private boolean[][] discovered;

  public MiniMap(Dungeon matrix) {
    this.dungeon = matrix;
    
    visited    = new boolean[dungeon.getRows()][dungeon.getCols()];
    discovered = new boolean[matrix.getRows()][matrix.getCols()];
  }

  public void display(Player walker) {
    boolean expanded = keyPressed && key == TAB;

    scale = expanded ? expandedScale : normalScale;
    this.spaceCell = expanded ? 10 : 3;

    cellSize = int(baseCellSize * scale);
    int radius   = expanded ? 5 : 2;

    PVector walkerPos = walker.getCurrentPos();
    int px = (int)walkerPos.x;
    int py = (int)walkerPos.y;

    // marcar habitacion actual como descubierta
    visited[py][px] = true;
    discovered[py][px] = true;
    
    // marcar habitaciones conectadas
    markAdjacentAsDiscovered(px, py);
    
    int mapSize = (radius*2+1) * cellSize;

    int startX = expanded ? width / 2 - mapSize / 2 : 20;
    int startY = expanded ? height / 2 - mapSize / 2 : 20;

    pushMatrix();
      translate(startX, startY);
  
      drawBackground(mapSize);
      drawRooms(px,py, cellSize, radius);
      drawConnections(px, py, radius);

    popMatrix();
  }
  
  private void drawBackground(int size) {
    stroke(0);
    strokeWeight(2*scale);
    fill(0,50);
    rect(0-6,0-6 , size + 11, size + 11, 8);
    noFill();
    noStroke();
  }
  
  private void drawRooms(int px, int py, int cellSize, int radius) {
    for (int dy = -radius; dy <= radius; dy++) {
      for (int dx = -radius; dx <= radius; dx++) {

        int mx = px + dx;
        int my = py + dy;

        if (!dungeon.isValid(mx, my)) continue;
        if (!discovered[my][mx]) continue;

        Room room = dungeon.getRoom(mx, my);
        if (room == null) continue;
        if (dungeon.getValue(my, mx) == 0) continue;

        int x = (dx + radius) * cellSize;
        int y = (dy + radius) * cellSize;
        
        // Determinamos el estado para el color
        boolean isVisited = visited[my][mx];
        
        drawRoomCell(room, x, y, cellSize,isVisited);

        if (mx == px && my == py) {
          drawPlayerMarker(x, y, cellSize);
        }
      }
    }
  }
  
  private void drawRoomCell(Room room, int x, int y, int size, boolean isVisited) {
    int alphaValue = isVisited ? 255 : 100; 
    color Color;

    // Fondo de la celda (el borde)
    fill(0, alphaValue * 0.8f);
    rect(x - spaceCell, y - spaceCell, size + spaceCell, size + spaceCell, 8*scale);

    // Color segun el tipo de habitacion
    switch (room.getType()) {
        case BOSS:     Color = color(200, 60, 60); break;
        case SUBBOSS:  Color = color(200, 140, 40); break;
        case TREASURE: Color = color(230, 200, 60); break;
        default:       Color = color(120); // Color gris
    }
    
    fill(Color, alphaValue);
    rect(x, y, size - this.spaceCell, size - this.spaceCell, 4*scale);
  }

  private void drawPlayerMarker(int x, int y, int size) {
    fill(80, 200, 255);
    rect(x, y, size - this.spaceCell, size - this.spaceCell, 4*scale);
  }

  private void markAdjacentAsDiscovered(int px, int py) {
    int val = dungeon.getValue(py, px);

    for (DungeonDir d : DungeonDir.values()) {
      if (!d.isOpen(val)) continue;
  
      int nx = px + d.dx;
      int ny = py + d.dy;
  
      if (dungeon.isValid(nx, ny)) {
        discovered[ny][nx] = true;
      }
    }
  }
  
  private void drawConnections(int px, int py, int radius) {
    for (int dy = -radius; dy <= radius; dy++) {
      for (int dx = -radius; dx <= radius; dx++) {
  
        int mx = px + dx;
        int my = py + dy;
  
        if (!dungeon.isValid(mx, my)) continue;
        if (!discovered[my][mx]) continue;
  
        int val = dungeon.getValue(my, mx);
  
        int x = dx + radius;
        int y = dy + radius;
  
        for (DungeonDir d : DungeonDir.values()) {
          if (!d.isOpen(val)) continue;
  
          int nx = mx + d.dx;
          int ny = my + d.dy;
  
          if (isDiscovered(nx, ny)) {
            drawConnection(
              x, y,
              x + d.dx, y + d.dy
            );
          }
        }
      }
    }
  }


  private boolean isDiscovered(int x, int y) {
    return dungeon.isValid(x, y) && discovered[y][x];
  }

  private void drawConnection(int x1, int y1, int x2, int y2) {
    stroke(#6C6C6C, 120);
    strokeWeight(2*scale);
    line(
      x1 * cellSize + cellSize / 2 -1*scale,
      y1 * cellSize + cellSize / 2 -1*scale ,
      x2 * cellSize + cellSize / 2 -1*scale,
      y2 * cellSize + cellSize / 2 -1*scale
    );
    noStroke();
    strokeWeight(0);
  }
}
