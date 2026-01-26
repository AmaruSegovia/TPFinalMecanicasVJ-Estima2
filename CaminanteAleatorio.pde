class CaminanteAleatorio {
  private PVector pos; // Posicion actual del caminante
  private PVector start; // El inicio del recorrido
  private ArrayList<PVector> recorrido; 
  
  private LevelLayout layout;

  public CaminanteAleatorio() {
    this.recorrido = new ArrayList<>();
    this.layout = new LevelLayout();
  }

  /** Genera el nivel y devuelve la configuracion */
  public LevelLayout generate(Dungeon m) {
    m.startDungeon(); // Limpiar matriz
    recorrido.clear();
    
    // Posicion inicial aleatoria
    int x = int(random(m.getCols())); 
    int y = int(random(m.getRows())); 
    this.pos = new PVector(x, y);
    this.start = pos.copy();
    this.recorrido.add(pos.copy());
    
    this.layout.startPos = this.start;
    
    // Caminata aleatoria
    while (m.nonZeroCount() < indexNonZero) {
      move(m);
    }
    
    calculateSpecialRooms(m);
    return this.layout;
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
      this.pos = newPos.copy();
      this.recorrido.add(pos.copy());
    }
  }
  
  private void calculateSpecialRooms(Dungeon m) {
    // 1. Boss
    this.layout.bossPos = this.pos.copy();
    
    // 2. Sub Boss
    if (recorrido.size() > 2) {
      int indice = (int) random(1, recorrido.size() - 2); 
      this.layout.subBossPos = recorrido.get(indice).copy();
    } else {
      this.layout.subBossPos = start.copy(); 
    }
    
    // 3. Tesoro
    layout.treasureRooms.clear();
    ArrayList<PVector> leafRooms = new ArrayList<PVector>();
    
    for (int i = 0; i < m.getRows(); i++) {
      for (int j = 0; j < m.getCols(); j++) {
        int val = m.getValue(i, j);
        if (val == 0) continue;
        
        // Contar puertas (bits)
        int doorsCount = 0;
        if ((val & 1) != 0) doorsCount++;
        if ((val & 2) != 0) doorsCount++;
        if ((val & 4) != 0) doorsCount++;
        if ((val & 8) != 0) doorsCount++;
        
        if (doorsCount == 1) {
          PVector roomPos = new PVector(j, i);
          // No puede ser la misma que start, boss o subboss
          if (!roomPos.equals(layout.startPos) && 
              !roomPos.equals(layout.bossPos) &&
              !roomPos.equals(layout.subBossPos)) {
             leafRooms.add(roomPos); 
          }
        }
      }
    }

    // Elegir solo una sala de tesoro aleatoria si hay opciones
    if (leafRooms.size() > 0) {
      int randIdx = (int)random(leafRooms.size());
      layout.treasureRooms.add(leafRooms.get(randIdx));
    }
  }
  /* -- ASESORES -- */
  public PVector getStartPos() { return start == null ? new PVector() : start.copy(); }
  public PVector getCurrentPos() { return pos == null ? new PVector() : pos.copy(); }
  public PVector getSubBossPos() { return layout.subBossPos == null ? new PVector() : layout.subBossPos.copy(); }
}
