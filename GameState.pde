// Interfaz que define el contrato para todos los estados del juego
interface GameState {
  void onEnter();    // Se ejecuta al entrar al estado
  void update();     // Renderizado del estado
  void handleInput(char key); // Manejo de los inputs, especificamente poara cada estado
}

// Estado del juego que representa la pantalla de juego
public class PlayingState implements GameState {
  private AudioManager audio;
  private InputManager input;
  private Player jugador;
  private Dungeon dungeon;
  private RoomRenderer renderer;
  private BulletFactory bulletFactory;
  private CaminanteAleatorio walker; 
  
  // Constructor, recibe el gestor de audio y entradas
  public PlayingState(AudioManager audio, InputManager input) {
    this.audio = audio;
    this.input = input;
    this.dungeon = new Dungeon(rows, cols);
    // Crear la matriz y el caminante
    this.walker = new CaminanteAleatorio(dungeon);
    
    PVector bossPos = walker.getCurrentPos();
    
    dungeon.generateRooms(dungeon.getMatriz(), bossPos);
    
    println("El jefe aparecerá en fila " + bossPos.y + " , columna " + bossPos.x);
    
    
    this.renderer = new RoomRenderer(dungeon, new GestorBullets());
    this.jugador = new Player(new PVector(width/2, height/2),walker.getStartPos());
    this.bulletFactory = new BulletFactory();
  }
  /* inicializa al entrar al juego */
  public void onEnter() {
    this.audio.playJuego();
  }
  
  /* Dibujando la pantalla */
  void update() {
    jugador.mover(input);
    jugador.shoot(renderer.getBullets(), input, bulletFactory);
    jugador.updateAnimation(input);
    
    renderer.render(jugador,walker);
    jugador.display();
    
    
    //if (jugadorGana()) changeState(victoria);
     if (jugadorPierde()) changeState(derrota);
    
    // ************************   DEPURADOR
    fill(255);
    textSize(20);
    text("vida: " + jugador.getLives(), 150, 30);
  }
  
  /* reconociendo inputs */
  void handleInput(char key) {
    if (key == 'r' || key == 'R' ) 
      changeState(new PlayingState(audio, input));
  
  }
  
  //boolean jugadorGana() {
  //  //if(jugador.col == 4 && jugador.row ==1) { return true; }
  //  // return false;
  //}
  
  boolean jugadorPierde() {
    // Comprueba si la columna del jugador es 3
    if (jugador.getLives() <= 0) { return true; }
    return false;
  }
  public void displayPlayerPosition() {
    fill(0);
    textSize(16);
    text("pos: "+jugador.getPosicion(), 10, 20);
  }
}

// Estado del juego que representa el menu inicial
public class MenuState implements GameState {
  private AudioManager audio;
  private PImage img = loadImage("splash.png");
  
  // Constructor, recibe el gestor de audio
  public MenuState(AudioManager audio) { 
    this.audio = audio; 
  }
  /* inicializa al entrar al menu */
  public void onEnter() {
    this.audio.playTitulo(); 
  }
  
  /* Dibujando la pantalla */
  void update() {
    imageMode(CORNER);
    tint(255);
    image(this.img, 0,0, 900, 800);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("Presiona ENTER para jugar", width / 2, height / 1.5 + 20*(sin(millis()*0.003)+5));
  }
  
  /* reconociendo inputs */
  void handleInput(char key) {
    if (key == ENTER) 
      changeState(new PlayingState(audio, input));
  }
}

// Estado del juego que representa el menu de vistoria
public class VictoryState implements GameState {
  private AudioManager audio;
  private PImage img = loadImage("victory.png");
  
  // Constructor, recibe el gestor de audio
  public VictoryState(AudioManager audio) { 
    this.audio = audio;  
  }
  /* inicializa al entrar a la pantalla de vctoria */
  public void onEnter() {
    this.audio.playVictoria();
  }
  /* Dibujando la pantalla */
  void update() {
    imageMode(CORNER);
    tint(255);
    image(this.img, 0,0, 900, 800);
    fill(#12DB94);
    textAlign(CENTER, CENTER);
    textSize(20*(sin(millis()*0.005)+5));
    text("¡VICTORIA!", width / 2, height / 6.5);
    textSize(20);
    text("Presiona ENTER para continuar", width / 2, height / 4.3);
    textSize(30);
  }
  
  /* reconociendo inputs */
  void handleInput(char key) {
    if (key == ENTER) {
      changeState(creditos); 
    }
  }
}

// Estado del juego que representa el menu de Game over
public class GameOverState implements GameState {
  private AudioManager audio;
  private PImage img = loadImage("defeat.png");
  
  // Constructor, recibe el gestor de audio
  public GameOverState(AudioManager audio) { 
    this.audio = audio;  
  }
  /* inicializa al entrar a la pantalla de derrota */
  public void onEnter() {
    this.audio.playDerrota();
  }
  /* Dibujando la pantalla */
  void update() {
    imageMode(CORNER);
    tint(255);
    image(img, 0,0, 900, 800);
    fill(#FF1265);
    textAlign(CENTER, CENTER);
    textSize(36);
    text("Has muerto", width / 2.5 + 20*(sin(millis()*0.001)+5), height / 6);
    textSize(16);
    text("Presiona ENTER para volver al menú", width / 2, height / 5);
  }
  
  /* reconociendo inputs */
  void handleInput(char key) {
    if (key == ENTER) {
      changeState(menu); 
    }
  }
}

// Estado del juego que representa la pantalla de creditos
public class CreditsState implements GameState {
  private AudioManager audio;
  private PImage img = loadImage("creditos.png");
  
  // Constructor, recibe el gestor de audio
  public CreditsState(AudioManager audio) { 
    this.audio = audio;  
  }
  /* inicializa al entrar a los creditos */
  public void onEnter() {
    // Ponerle musiquita
  }
  /* Dibujando la pantalla */
  void update() {
    imageMode(CORNER);
    image(img, 0,0, 900, 800);
  }
  
  /* reconociendo inputs */
  void handleInput(char key) {
    if (key == ENTER) {
      changeState(menu); 
    }
  }
}
