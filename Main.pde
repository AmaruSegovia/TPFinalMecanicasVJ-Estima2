import java.util.Collection;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayDeque;
import java.util.Deque;


/**Variables Globales--------*/
public int nivel = 1;
int cols; // Numero de columnas de la matriz
int rows; // Numero de filas de la matriz
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
Difficulty difficulty = Difficulty.NORMAL;

// --- Setup Global ---
public void setup()
{
  noSmooth();
  size(900, 800);

  // Inicializar Managers
  audio = new AudioManager(this);
  input = new InputManager();

  PFont pixelFont = createFont("pixelFont.ttf", 20);
  textFont(pixelFont);


  // Inicializar estados
  menu = new MenuState(audio);
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

int BASE_MIN_ROOMS = 6;
int BASE_MAX_ROOMS = 8;

void prepareDungeonValues() {

  float baseSize = random(4, 8);

  // crecimiento suave por nivel
  float levelMultiplier = 1.0 + (nivel - 1) * 0.35;

  // dificultad ajusta sin romper
  float difficultyMultiplier = difficulty.multidungeon;

  // tamaño final
  int size = int(baseSize * levelMultiplier);

  // limites
  size = constrain(size, 4, 16);

  cols = size;
  rows = size;
  
  int minRooms = int(5 * levelMultiplier * difficultyMultiplier);
  int maxRooms = int(8 * levelMultiplier * difficultyMultiplier);

  indexNonZero = int(random(minRooms, maxRooms + 1));
  cellSize = width / size;

  println("----- DUNGEON PREPARADA -----");
  println("Dificultad: " + difficulty);
  println("Nivel: " + nivel);
  println("Rooms totales: " + indexNonZero);
  println("Matriz: " + rows + " x " + cols);
}
