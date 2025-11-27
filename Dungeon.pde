/* Clase que se encarga de crear las habitaciones segun el nivel. */
class Dungeon {

  private int nivel;
  private int cols, rows; // Numero de columnas y filas en la matriz de habitaciones
  
  private int[][] matriz;
  private Room[][] rooms; // Matriz de las habitaciones que hay en la dungeon

  /* -- CONSTRUCTORES -- */
  /** Constructor por defecto*/
  public Dungeon() {
    println("Aun no has inicializado nada");
  }
  /** constructor parametrizado */
  public Dungeon(int rows, int cols) {
    //this.nivel = nivel;
    this.cols = cols;
    this.rows = rows;
    
    this.matriz = new int[this.rows][this.cols];
    this.matriz = startDungeon();
    this.rooms = new Room[this.rows][this.cols];
    
  }

  /* -- METODOS -- */
  /** Metodo que inicia la dungeon segun el nivel */
  public int[][] startDungeon() {
    // Inicializar la matriz con ceros
    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j < this.cols; j++) {
        this.matriz[i][j] = 0;
      }
    }
    return this.matriz;
  }

  /** Metodo que genera las habitaciones */
  public void generateRooms(int[][] matriz, PVector bossPos) {
    int cont = 0;
    for (int i = 0; i < this.rows; i++) {
        for (int j = 0; j < this.cols; j++) {
            PVector pos = new PVector(j, i);
            // Si esta celda es la del boss, crear BossRoom
            if (bossPos != null && pos.equals(bossPos)) {
                this.rooms[i][j] = new BossRoom(matriz[i][j], width+1, height+1, new PVector(0, 0), cont);
            } else {
                // En cualquier otro caso, crear Room normal
                this.rooms[i][j] = new Room(matriz[i][j], width+1, height+1, new PVector(0, 0), cont);
            }
            cont++;
        }
    }
  }


  /** Metodo que devuelve el objeto habitacion */
  public Room getRoom(int col, int row) {
    // segun si la columna y fila solicitada estan dentro del limite de la matriz
    if (col >= 0 && col < this.cols && row >= 0 && row < this.rows) {
      return this.rooms[row][col];
    }
    println("Room Inexistente por estar fuera de rango");
    return null;
  } 
  /** Metodo que devuelve la cantidad de celdas distintas a 0 */
  public int nonZeroCount() {
    int count = 0;
    for (int[] row : matriz) {
      for (int col : row) {
        if (col != 0) {
          count++;
        }
      }
    }
    return count;
  }
  
  /*** Cambios en la Dungeon ***/
    /** Metodo que dibuja la matriz */
  void display() {
    stroke(0);
    fill(255);

    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j < this.cols; j++) {
        int x = j * cellSize;
        int y = i * cellSize;

        rect(x, y, cellSize, cellSize);

        // Dibujar conexiones segun el valor binario de la matriz
        int val = this.matriz[i][j];
        if ((val & 1) != 0) line(x + cellSize / 2, y + cellSize / 2, x + cellSize / 2, y); // Arriba dibuja una linea si el primer bit esta activo
        if ((val & 2) != 0) line(x + cellSize / 2, y + cellSize / 2, x + cellSize, y + cellSize / 2); // Derecha dibuja una linea si el segundo bit esta activo
        if ((val & 4) != 0) line(x + cellSize / 2, y + cellSize / 2, x + cellSize / 2, y + cellSize); // Abajo dibuja una linea si el tercero bit esta activo
        if ((val & 8) != 0) line(x + cellSize / 2, y + cellSize / 2, x, y + cellSize / 2); // Izquierda dibuja una linea si el cuarto bit esta activo

        // Mostrar el valor de la celda
        fill(0);
        textAlign(CENTER, CENTER);
        text(val, x + cellSize / 2, y + cellSize / 2);
        fill(255);
      }
    }
  }
  /** Metodo que muestra la matriz por consola */
  public void printMatrix() {
    for (int[] row : matriz) {
      for (int col : row) {
        print(col + " ");
      }
      println();
    }
  }
  
  /** Metodo que agrega valores a las ponicion actual y la anterior*/
  public void addValue(PVector lastPos, PVector currentPos, int value, int reverseValue){
    // primero en Y porque recorremos la matriz segun las filas
    combineValue(int(lastPos.y), int(lastPos.x), value); // Agregar el valor al indice actual
    combineValue(int(currentPos.y), int(currentPos.x), reverseValue); // Agregar el valor al indice al que se movio
  }
  
  /** Metodo que combina los valores de una celda especifica de la matriz */
  public void combineValue(int y, int x, int newValue) {
    this.matriz[y][x] |= newValue; // Usa el operador OR bit a bit para comparar entre el valor que tenia el indice y el nuevo valor
  }
  
  /* -- ASESORES -- */
  /* Getters */
  /** Devuelve el numero de columnas */
  public int getCols(){
    return this.cols;
  }
  /** Devuelve el numero de filas */
  public int getRows(){
    return this.rows;
  }
  /** Devuelve el numero de filas */
  public int[][] getMatriz(){
    return this.matriz;
  }
  
  /** Retorna el valor de un indice especifico */
  public int getValue(int y, int x) {  return this.matriz[y][x];  }
}
