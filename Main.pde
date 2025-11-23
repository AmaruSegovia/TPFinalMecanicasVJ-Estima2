import java.util.Collection;
import java.util.Map;
import java.util.HashMap;


/**Variables Globales--------*/
public boolean W_PRESSED;
public boolean D_PRESSED;
public boolean S_PRESSED;
public boolean A_PRESSED;
public int nivel = 1;
public int estadoJuego = 0;

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

private Player jugador;

PImage background;

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


void jugando() {
  //dungeon.displayRoom(jugador, gestorEnemigos, gestorBalas);
  jugador.display(); 
  jugador.mover(input);
  
  /* Regulando disparo a la vez que mantiene la animación de disparo mientras no se pueda disparar */
  if (millis() - jugador.getTimeSinceLastShot() >= 310) {
    jugador.setIsShooting(false);
    if (jugador.getAnimationState() == MaquinaEstadosAnimacion.ATAQUE_DERECHA){
      jugador.setAnimationState(MaquinaEstadosAnimacion.ESTATICO_DERECHA);
    }
    else if (jugador.getAnimationState() == MaquinaEstadosAnimacion.ATAQUE_IZQUIERDA){
      jugador.setAnimationState(MaquinaEstadosAnimacion.ESTATICO_IZQUIERDA);
    }
  }
}


boolean jugadorGana() {
  if(jugador.col == 4 && jugador.row ==1)
  {
    return true;
  }
   return false;
}

boolean jugadorPierde() {
  // Comprueba si la columna del jugador es 3
  if (jugador.getLives() <= 0) {
    return true;
  }
  return false;
}

// --- Control de teclas ---
void keyPressed() {
  input.keyPressed(key);
  currentState.handleInput(key);
}
void keyReleased() {
  input.keyReleased(key);
}

/*public void keyPressed() {
  char input = Character.toLowerCase(key);
  switch (input) { // convierte la tecla a minuscula
  case 'w':
    W_PRESSED = true;
    break;
  case 's':
    S_PRESSED = true;
    break;
  case 'a':
    jugador.setAnimationState(MaquinaEstadosAnimacion.MOV_IZQUIERDA);
    A_PRESSED = true;
    break;
  case 'd':
    jugador.setAnimationState(MaquinaEstadosAnimacion.MOV_DERECHA);
    D_PRESSED = true;
    break;
  case 'j':
    jugador.setAnimationState(MaquinaEstadosAnimacion.ATAQUE_IZQUIERDA);
    break;
  case 'l':
    jugador.setAnimationState(MaquinaEstadosAnimacion.ATAQUE_DERECHA);
    break;
  }
  
  /* Verificando que el jugador mantenga su orientación al moverese arriba o abajo */
  /*if (S_PRESSED || W_PRESSED){
    if (jugador.getAnimationState() == MaquinaEstadosAnimacion.ESTATICO_DERECHA){
      jugador.setAnimationState(MaquinaEstadosAnimacion.MOV_DERECHA);
    }
    else if (jugador.getAnimationState() == MaquinaEstadosAnimacion.ESTATICO_IZQUIERDA){
      jugador.setAnimationState(MaquinaEstadosAnimacion.MOV_IZQUIERDA);
    }
  }
  
  /* Disparando y seteando el tiempo de disparo */
  /*if ((input == 'i' || input == 'j' || input == 'k' || input == 'l') && !jugador.getIsShooting()) {
    gestorBalas.addBullet(jugador.shoot(input));
    jugador.setTimeSinceLastShot(millis());
    jugador.setIsShooting(true);    
  }  
  
  /* Verificando que el jugador mantenga su orientación al disparar mientras se mueve arriba o abajo */
  /*if (input == 'i' || input == 'k'){
    if (jugador.getAnimationState() == MaquinaEstadosAnimacion.ESTATICO_DERECHA ||
        jugador.getAnimationState() == MaquinaEstadosAnimacion.MOV_DERECHA){
      jugador.setAnimationState(MaquinaEstadosAnimacion.ATAQUE_DERECHA);
    }
    else if (jugador.getAnimationState() == MaquinaEstadosAnimacion.ESTATICO_IZQUIERDA ||
        jugador.getAnimationState() == MaquinaEstadosAnimacion.MOV_IZQUIERDA){
      jugador.setAnimationState(MaquinaEstadosAnimacion.ATAQUE_IZQUIERDA);
    }
  }
  
  if (estadoJuego == EstadoJuego.MENU && key == ENTER) {
      iniciarJuego();
      } else if ((estadoJuego == EstadoJuego.DERROTA || estadoJuego == EstadoJuego.CREDITOS) && key == ENTER) {
      estadoJuego = EstadoJuego.MENU;
      }else if (estadoJuego == EstadoJuego.VICTORIA && key == ENTER)
      {
      estadoJuego = EstadoJuego.CREDITOS;
    }
}*/


//public void keyReleased() {
//  switch (Character.toLowerCase(key)) { // convierte la tecla a minuscula 
//    case 'w':
//      W_PRESSED = false;
//      break;
//    case 's':
//      S_PRESSED = false;
//      break;
//    case 'a':
//      A_PRESSED = false;
//      break;
//    case 'd':
//      D_PRESSED = false;
//      break;
//  }
  
//  if (!A_PRESSED == !S_PRESSED == !W_PRESSED == !D_PRESSED){
//    if (jugador.getAnimationState() == MaquinaEstadosAnimacion.MOV_DERECHA){
//      jugador.setAnimationState(MaquinaEstadosAnimacion.ESTATICO_DERECHA);
//    }
//    else if (jugador.getAnimationState() == MaquinaEstadosAnimacion.MOV_IZQUIERDA){
//      jugador.setAnimationState(MaquinaEstadosAnimacion.ESTATICO_IZQUIERDA);
//    }
//  }
//}

public void displayPlayerPosition() {
  fill(0);
  textSize(16);
  text("pos: "+jugador.getPosicion(), 10, 20);
}
