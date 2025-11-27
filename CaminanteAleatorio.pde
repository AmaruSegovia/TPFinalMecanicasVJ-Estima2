class CaminanteAleatorio {
  private PVector pos; // Posicion actual del caminante
  private PVector start; // El inicio del recorrido
  private PVector lastPos;
  private color Color;

  public CaminanteAleatorio(Dungeon m) {
    int x = int(random(m.getCols())); // aleatoria dentro de la matriz
    int y = int(random(m.getRows())); // aleatoria dentro de la matriz
    this.pos = new PVector(x, y); // posicion aleatoria dentro de la matriz
    this.start = pos.copy();    
    this.Color = color(0, 0, 255, 100);
    while (m.nonZeroCount() < indexNonZero) {
      move(m);
    }
    
    // actualizar las rooms con la matriz final
    m.generateRooms(m.getMatriz());
    println("Dungeon completada con " + m.nonZeroCount() + " celdas distintas de cero");
    m.printMatrix();
  }

  public void move(Dungeon matrix) {
    int dir = int(random(4)); // 0: arriba, 1: derecha, 2: abajo, 3: izquierda
    PVector newPos = pos.copy();

    switch (dir) {
      case 0: newPos.y--; break; // Mover hacia arriba
      case 1: newPos.x++; break; // Mover hacia la derecha
      case 2: newPos.y++; break; // Mover hacia abajo
      case 3: newPos.x--; break; // Mover hacia la izquierda
    }

    // Verificando que las nuevas coordenadas esten dentro de los limites de la matriz
    if (newPos.x >= 0 && newPos.x < matrix.getCols() && newPos.y >= 0 && newPos.y < matrix.getRows()) {
      
      // << operador de desplazamiento, desplaza los bits hacia la izquierda segun la direccion de desplazamiento
      int binaryValue = 1 << dir; // Calcular el valor binario segun la direccion
      int reverseBinaryValue = 1 << ((dir + 2) % 4); // Calcular el valor binario de la direccion opuesta

      // Actualizando los valores de la matriz
      matrix.addValue(pos, newPos, binaryValue, reverseBinaryValue);

      // Mover el caminante a la nueva posicion
      this.lastPos = pos.copy();
      this.pos = newPos.copy();
    }
  }

  public void display() {
    // Resaltar la posicion actual del caminante
    fill(Color);
    noStroke();
    rect(pos.x * cellSize, pos.y * cellSize, cellSize, cellSize);
  }

  /* -- ASESORES -- */
  public void setColor(color Color) {  this.Color = Color;  }
  
  public PVector getStartPos() {
    return start.copy();              //  para consultar inicio
  }

  public PVector getCurrentPos() {
    return pos.copy();                // posición actual
  }
  public PVector getLastPos() { return lastPos.copy(); }
}
