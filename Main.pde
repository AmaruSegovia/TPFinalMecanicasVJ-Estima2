import java.util.Collection;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayDeque;
import java.util.Deque;


/**Variables Globales--------*/
public int nivel = 1;
int cols = int(random(6, 6)); // Número de columnas de la matriz
int rows = int(random(6, 6)); // Número de filas de la matriz
int cellSize;
int indexNonZero;

boolean start = false;

import ddf.minim.*;

// --- Managers ---
AudioManager audio;
InputManager input;

// --- estados de Juego ---
GameState currentState;
MenuState menu;
PlayingState jugando;
VictoryState victoria;
GameOverState derrota;
CreditsState creditos;

// -- Variables globales --
PImage background;

// --- Setup Global ---
public void setup()
{
  // Establecer un numero aleatorio entre el valor mas alto entre la columna o la fila y la suma de estas para los elementos diferentes de cero
  indexNonZero = int(random(((cols > rows) ? cols : rows), (cols+rows)));
  println("Matriz de "+ rows+" , "+cols );
  println("Número objetivo de elementos diferentes de cero: " + indexNonZero);
  
  cellSize = width / ((cols > rows) ? cols : rows); // se divide segun el maximo entre las cols y rows

  noSmooth();
  size(900, 800);
  
  // Inicializar Managers
  audio = new AudioManager(this);
  input = new InputManager();
  
  PFont pixelFont = createFont("pixelFont.ttf", 20);
  textFont(pixelFont);
  
  
  // Inicializar estados
  menu = new MenuState(audio);
  jugando = new PlayingState(audio,input);
  victoria = new VictoryState(audio);
  derrota = new GameOverState(audio);
  creditos = new CreditsState(audio);
  
   // Estado inicial
  changeState(menu); 
}

public void draw() {
  background(0);
  currentState.update();
  //println(frameRate);
}

void changeState(GameState newState) {
  currentState = newState;
  currentState.onEnter(); // activa lo inicial, como el setup al momenbto de cambiar de estado
}

// --- Control de teclas ---
void keyPressed() {
  input.keyPressed(key);
  currentState.handleInput(key);
}
void keyReleased() {
  input.keyReleased(key);
}
