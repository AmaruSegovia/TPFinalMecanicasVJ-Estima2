/* Clase que se encarga de crear y gestionar las habitaciones segun el nivel. */
class Dungeon {
  private GestorEnemigos gestorEnemigos;

  private int nivel;
  private int cols, rows; // Número de columnas y filas en la matriz de habitaciones
  private int[][] matriz; // Representa la matriz de la dungeon con enteros para definir las puertas mas adelante
  private Room[][] rooms; // Matriz de las habitaciones que hay en la dungeon

  /* -- CONSTRUCTORES -- */
  /** Constructor por defecto*/
  public Dungeon() {
    this.nivel = 1;
  }
  /** constructor parametrizado */
  public Dungeon(int nivel) {
    this.nivel = nivel;
    this.matriz = startDungeon();
    this.cols = matriz[0].length;
    this.rows = matriz.length;
    this.rooms = new Room[this.rows][this.cols];  // Inicialización de las dimenciones de la matriz de habitaciones
    this.gestorEnemigos=new GestorEnemigos();
    generateRooms();
  }

  /* -- METODOS -- */
  /** Metodo que inicia la dungeon segun el nivel */
  public int[][] startDungeon() {
    switch (this.nivel) {
    case 1:
      return new int[][] {
        {2, 14, 12, 0},
        {0, 3, 11, 8}
      };
    case 2:
      return new int[][] {
        {2, 14, 11, 0},
        {0, 3, 15, 8},
        {0, 3, 11, 8}
      };
    default:
      // Valor por defecto si el nivel no esta definido.
      return new int[][] {
        {0}
      };
    }
  }

  /** Metodo que genera las habitaciones */
  public void generateRooms() {
    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j < this.cols; j++) {
        this.rooms[i][j] = new Room(matriz[i][j], width+1, height+1, new PVector(0, 0));
        if (j > 0 && j < 3) {
          this.gestorEnemigos.inicializarEnemigos(this.rooms[i][j]);
        }
        if (j > 2){
          this.gestorEnemigos.inicializarBoss(this.rooms[i][j]);
        }
      }
    }
  }

  /** Metodo que dibuja la habitacion actual*/
  public void displayRoom(Player jugador, GestorEnemigos enemies, GestorBullets balas) {
    Room roomActual = dungeon.getRoom(jugador.col, jugador.row);
    if (roomActual != null) { // si existe:
      roomActual.display();
      roomActual.updateDoors();
      if (roomActual == dungeon.getRoom(0,0)){
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
      jugador.checkCollisions(roomActual);
      // Verificar colisiones con las puertas
      balas.updateBullets(roomActual);
      balas.dibujarBalas();
      enemies.actualizar(roomActual);
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
}
