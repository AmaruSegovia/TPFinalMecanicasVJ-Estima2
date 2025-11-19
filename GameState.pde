interface GameState {
  void update();
  void render();
  void handleInput(char key);
}

class MenuState implements GameState {
  AudioManager audio;
  MenuState(AudioManager audio) { 
    this.audio = audio; 
    this.audio.playTitulo(); 
  }
  
  void update() { }
  void render() {
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
      currentState = playingState;
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
    audio.playJuego();
    dungeon = new Dungeon(1);
    jugador = new Player(new PVector(width/2, height/2));
  }
  
  void update() {
    text("Estando en el juego", width / 2, height / 1.5 + 20*(sin(millis()*0.003)+5));
  }
  
  void render() {
  }
  
  void handleInput(char key) { 
    println("Teclas");
  }
}
