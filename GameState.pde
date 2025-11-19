interface GameState {
  void onEnter();
  void update();
  void handleInput(char key);
}

public class MenuState implements GameState {
  AudioManager audio;
  MenuState(AudioManager audio) { 
    this.audio = audio; 
  }
  
  public void onEnter() {
    this.audio.playTitulo(); 
  }
  void update() {
    imageMode(CORNER);
    tint(255);
    image(loadImage("splash.png"), 0,0, 900, 800);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("Presiona ENTER para jugar", width / 2, height / 1.5 + 20*(sin(millis()*0.003)+5));
  }
  void handleInput(char key) {
    if (key == ENTER) 
      changeState(jugando);
  }
}

public class PlayingState implements GameState {
  AudioManager audio;
  InputManager input;
  Player jugador;
  Dungeon dungeon;
  
  PlayingState(AudioManager audio, InputManager input) {
    this.audio = audio;
    this.input = input;
    dungeon = new Dungeon(1);
    jugador = new Player(new PVector(width/2, height/2));
  }
  public void onEnter() {
    this.audio.playJuego();
  }
  void update() {
    text("Estando en el juego", width / 2, height / 1.5 + 20*(sin(millis()*0.003)+5));
  }
  
  void handleInput(char key) { 
    if (key == ENTER) 
      changeState(victoria);
    if (keyCode == UP) 
      changeState(creditos);
    if (keyCode == DOWN) 
      changeState(derrota);
  }
}

public class VictoryState implements GameState {
  AudioManager audio;
  VictoryState(AudioManager audio) { 
    this.audio = audio;  
  }
  public void onEnter() {
    this.audio.playVictoria();
  }
  void update() {
    imageMode(CORNER);
    tint(255);
    image(loadImage("victory.png"), 0,0, 900, 800);
    fill(#12DB94);
    textAlign(CENTER, CENTER);
    textSize(20*(sin(millis()*0.005)+5));
    text("¡VICTORIA!", width / 2, height / 6.5);
    textSize(20);
    text("Presiona ENTER para continuar", width / 2, height / 4.3);
    textSize(30);
  }
  void handleInput(char key) {
    if (key == ENTER) {
      changeState(menu); 
    }
  }
}

public class GameOverState implements GameState {
  AudioManager audio;
  GameOverState(AudioManager audio) { 
    this.audio = audio;  
  }
  public void onEnter() {
    this.audio.playDerrota();
  }
  void update() {
    imageMode(CORNER);
    tint(255);
    image(loadImage("defeat.png"), 0,0, 900, 800);
    fill(#FF1265);
    textAlign(CENTER, CENTER);
    textSize(36);
    text("Has muerto", width / 2.5 + 20*(sin(millis()*0.001)+5), height / 6);
    textSize(16);
    text("Presiona ENTER para volver al menú", width / 2, height / 5);
  }
  void handleInput(char key) {
    if (key == ENTER) {
      changeState(menu); 
    }
  }
}

public class CreditsState implements GameState {
  AudioManager audio;
  CreditsState(AudioManager audio) { 
    this.audio = audio;  
  }
  public void onEnter() {
    // Ponerle musiquita
  }
  void update() {
    imageMode(CORNER);
    image(loadImage("creditos.png"), 0,0, 900, 800);
  }
  void handleInput(char key) {
    if (key == ENTER) {
      changeState(menu); 
    }
  }
}
