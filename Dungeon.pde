/* Clase que se encarga de crear las habitaciones segun el nivel. */
class Dungeon {

  private int nivel;
  private int cols, rows; // Número de columnas y filas en la matriz de habitaciones
  private Room[][] rooms; // Matriz de las habitaciones que hay en la dungeon

  /* -- CONSTRUCTORES -- */
  /** Constructor por defecto*/
  public Dungeon() {
    println("Aun no has inicializado nada");
  }
  /** constructor parametrizado */
  public Dungeon(int nivel) {
    this.nivel = nivel;
    int[][] matriz = startDungeon();
    this.cols = matriz[0].length;
    this.rows = matriz.length;
    this.rooms = new Room[this.rows][this.cols];  // Inicialización de las dimenciones de la matriz de habitaciones
    generateRooms(matriz);
  }

  /* -- METODOS -- */
  /** Metodo que inicia la dungeon segun el nivel */
  public int[][] startDungeon() {
    switch (this.nivel) {
    case 1:
      return new int[][] {
        {2, 14, 12, 0,0},
        {0, 3, 11, 10,0}
      };
    case 2:
    
    ;
    default:
      // Valor por defecto si el nivel no esta definido.
      return new int[][] {
        {0}
      };
    }
  }

  /** Metodo que genera las habitaciones */
  public void generateRooms(int[][] matriz) {
    int cont = 0;
    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j < this.cols; j++) {
        this.rooms[i][j] = new Room(matriz[i][j], width+1, height+1, new PVector(0, 0),cont);
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
  
  /* -- ASESORES -- */
  /* Getters */
  /** Devuelve el numero de columnas */
  public int getCols(){
    return this.cols;
  }
  /** Devuelve el numero de columnas */
  public int getRows(){
    return this.rows;
  }
}
