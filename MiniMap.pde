class MiniMap {
  private int width, height;
  private int cellSize = 35; // Tamaño de cada celda en el mini-mapa
  private Dungeon matrix;

  public MiniMap(int width, int height, Dungeon matrix) {
    this.width = width;
    this.height = height;
    this.matrix = matrix;
  }

  public void display(Player walker) {
    int mapCols = width / cellSize;
    int mapRows = height / cellSize;
    PVector walkerPos = walker.getCurrentPos();

    // Posición en la matriz que se corresponde con la esquina superior izquierda del mini-mapa
    int offsetX = (int) walkerPos.x - mapCols / 2;
    int offsetY = (int) walkerPos.y - mapRows / 2;

    // Dibujar el fondo del mini-mapa
    fill(200, 100);
    rect(0, 0, width, height);

    // Dibujar las celdas y conexiones en el mini-mapa
    for (int i = 0; i < mapCols; i++) {
      for (int j = 0; j < mapRows; j++) {
        int matrixX = offsetX + i;
        int matrixY = offsetY + j;

        if (isValidCell(matrixX, matrixY)) {
          // Dibujar celda activa si tiene valor diferente de cero
          if (matrix.getValue(matrixY, matrixX) != 0) {
            fill(#6C6C6C, 100);
            rect(i * cellSize+3, j * cellSize+3, cellSize-3, cellSize-3);
          }
          // Dibujar posición actual del caminante en color celeste
          if (matrixX == walkerPos.x && matrixY == walkerPos.y) {
            fill(0, 191, 255, 150); // Color celeste con transparencia
            rect(i * cellSize, j * cellSize, cellSize, cellSize);
          }

          // Dibujar conexiones según el valor binario de la matriz
          int val = matrix.getValue(matrixY, matrixX);
          if ((val & 1) != 0) drawConnection(i, j, i, j - 1); // Arriba
          if ((val & 2) != 0) drawConnection(i, j, i + 1, j); // Derecha
          if ((val & 4) != 0) drawConnection(i, j, i, j + 1); // Abajo
          if ((val & 8) != 0) drawConnection(i, j, i - 1, j); // Izquierda
        }
      }
    }
  }
  // Método para verificar si las coordenadas están dentro de los límites de la matriz
  private boolean isValidCell(int x, int y) {
    return x >= 0 && x < matrix.getCols() && y >= 0 && y < matrix.getRows();
  }

  // Método para dibujar una conexión entre dos celdas del mini-mapa
  private void drawConnection(int x1, int y1, int x2, int y2) {
    stroke(#6C6C6C,100);
    strokeWeight(2);
    line(x1 * cellSize + cellSize / 2, y1 * cellSize + cellSize / 2,
         x2 * cellSize + cellSize / 2, y2 * cellSize + cellSize / 2);
    noStroke();
    strokeWeight(1);
  }
}
