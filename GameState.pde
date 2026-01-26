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
  private GameAssets assets;
  private Notificaciones notificaciones;

  
  private MiniMap miniMap;
  
  // Constructor, recibe el gestor de audio y entradas
  public PlayingState(AudioManager audio, InputManager input) {
    this.audio = audio;
    this.input = input;
    this.dungeon = new Dungeon(rows, cols);
    // Crear la matriz y el caminante
    this.walker = new CaminanteAleatorio();
    
    // Cargar assets
    assets = new GameAssets();
    assets.load();
    
    // Generar layout del nivel
    LevelLayout layout = walker.generate(dungeon);
    
    dungeon.generateRooms(dungeon.getMatriz(), layout);
    
    println("El jefe aparecerá en fila " + layout.bossPos.y + " , columna " + layout.bossPos.x);
    
    this.notificaciones = new Notificaciones();
    this.renderer = new RoomRenderer(dungeon, new GestorBullets(), assets.getRoomVisuals(), notificaciones);
    this.jugador = new Player(new PVector(width/2, height/2),walker.getStartPos());
    this.bulletFactory = new BulletFactory();
    
    this.miniMap = new MiniMap( dungeon); // Crear el mini-mapa
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
    
    
    renderer.render(jugador);
    jugador.display();
    //effectManager.update();
    
    miniMap.display(jugador);
    
    // Dibujar notificaciones al final de todo
    notificaciones.updateAndDisplay();
    
     if (jugadorPierde()) changeState(derrota);
  }
  
  /* reconociendo inputs */
  void handleInput(char key) {
    if (key == 'r' || key == 'R' ) { 
      prepareDungeonValues();
      changeState(new PlayingState(audio, input));
    }
  }
  
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
  private int selectedIndex = 1; // NORMAL por defecto

  private PImage img;
  
  // Constructor, recibe el gestor de audio
  public MenuState(AudioManager audio) { 
    this.audio = audio;
    this.img = loadImage("splash.png"); 
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
    
    Difficulty[] diffs = Difficulty.values();
    
    pushMatrix();
      textAlign(CENTER);
      fill(255);
      textSize(28);
      
      int boxW = 200;
      int boxH = 50;
    
      translate(width/2 - boxW/2, height/2 - boxH/2);
      text("Dificultad", boxW/2, -20);
      
      for (int i = 0; i < diffs.length; i++) {
    
        int x = 0;
        int y = i * (boxH + 10);
    
        // Fondo del cuadro
        if (i == selectedIndex) {
          fill(255, 200, 0, 220); // seleccionado
        } else {
          fill(0,100);
        }
        noStroke();
        rect(x, y, boxW, boxH, 12);
    
        // Texto
        fill(255);
        textSize(20);
        text(diffs[i].name(), boxW/2, y + boxH/1.6);
      }
    
    popMatrix();

  }
  
  /* reconociendo inputs */
  void handleInput(char key) {

    int max = Difficulty.values().length;
  
    if (keyCode == UP || key == 'w' || key == 'W') {
      selectedIndex--;
      if (selectedIndex < 0) selectedIndex = max - 1;
    }
  
    if (keyCode == DOWN || key == 's' || key == 'S') {
      selectedIndex++;
      if (selectedIndex >= max) selectedIndex = 0;
    }
  
    if (key == ENTER) {
      difficulty = Difficulty.values()[selectedIndex];
      prepareDungeonValues();
      changeState(new PlayingState(audio, input));
    }
  }
}

// Estado del juego que representa el menu de vistoria
public class VictoryState implements GameState {
  private AudioManager audio;
  private PImage img;
  
  // Constructor, recibe el gestor de audio
  public VictoryState(AudioManager audio) { 
    this.audio = audio;
    this.img = loadImage("victory.png");
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
  private PImage img;
  
  // Constructor, recibe el gestor de audio
  public GameOverState(AudioManager audio) { 
    this.audio = audio;
    this.img = loadImage("defeat.png"); 
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
  private PImage img;
  
  // Constructor, recibe el gestor de audio
  public CreditsState(AudioManager audio) { 
    this.audio = audio;
    this.img = loadImage("creditos.png"); 
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
