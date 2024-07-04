/**Variables Globales--------*/
public boolean W_PRESSED;
public boolean D_PRESSED;
public boolean S_PRESSED;
public boolean A_PRESSED;
public int nivel = 1;
public int estadoJuego = 0;

import ddf.minim.*;
private Minim minim;
private AudioPlayer musicaTitulo;
private AudioPlayer musicaJuego;

private Dungeon dungeon;
private Player jugador;
private GestorBullets gestorBalas;
private GestorEnemigos gestorEnemigos;

public void setup()
{
  noSmooth();
  size(900, 800);
  minim = new Minim(this);
  musicaTitulo = minim.loadFile("musicaTitulo.mp3");
  musicaJuego = minim.loadFile("musicaJuego.mp3");
  musicaTitulo.setGain(-10);
  musicaJuego.setGain(-10);
  PFont pixelFont = createFont("pixelFont.ttf", 20);
  textFont(pixelFont);
  dungeon = new Dungeon(nivel);
  jugador = new Player(new PVector(width/2, height/2));
  gestorBalas = new GestorBullets();
  gestorEnemigos= new GestorEnemigos();
}

public void draw()
{
    background(100);
  switch (estadoJuego) {
    case EstadoJuego.MENU:
      mostrarMenu();
      break;
    case EstadoJuego.JUGANDO:
      jugando();
      break;
    case EstadoJuego.VICTORIA:
      mostrarVictoria();
      break;
    case EstadoJuego.DERROTA:
      mostrarDerrota();
      break;
  }
}

void jugando() {
  musicaTitulo.pause();
  musicaTitulo.rewind();
  musicaJuego.play();
  Room roomActual = dungeon.getRoom(jugador.col, jugador.row);
  println(jugador.row);
  if (roomActual != null) { // si existe:
    roomActual.display();
    // Verificar colisionescon las puertas
    jugador.checkCollisions(roomActual);
  }
  jugador.display(); 
  jugador.mover();
  gestorBalas.updateBullets(roomActual);
  
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

  gestorEnemigos.actualizar(roomActual);
  
  if (jugadorGana()) {
    estadoJuego = EstadoJuego.VICTORIA;
  } else if (jugadorPierde()) {
    estadoJuego = EstadoJuego.DERROTA;
  }
}

void mostrarMenu() {
  musicaJuego.pause();
  musicaJuego.rewind();
  musicaTitulo.play();
  background(0, 0, 128);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("MENU PRINCIPAL", width / 2, height / 2 - 40);
  textSize(16);
  text("Presiona ENTER para jugar", width / 2, height / 2);
}

void mostrarVictoria() {
  musicaJuego.pause();
  background(0, 128, 0);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("¡VICTORIA!", width / 2, height / 2 - 40);
  textSize(16);
  text("Presiona ENTER para volver al menú", width / 2, height / 2);
}

void mostrarDerrota() {
  musicaJuego.pause();
  background(128, 0, 0);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("DERROTA", width / 2, height / 2 - 40);
  textSize(16);
  text("Presiona ENTER para volver al menú", width / 2, height / 2);
}

boolean jugadorGana() {
    //if (jugador.row == 1) {
   // return true;
 // }
  return false;
}

boolean jugadorPierde() {
  // Comprueba si la columna del jugador es 3
 // if (jugador.col == 2) {
  //  return true;
  //}
  return false;
}


public void keyPressed() {
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
  if (S_PRESSED || W_PRESSED){
    if (jugador.getAnimationState() == MaquinaEstadosAnimacion.ESTATICO_DERECHA){
      jugador.setAnimationState(MaquinaEstadosAnimacion.MOV_DERECHA);
    }
    else if (jugador.getAnimationState() == MaquinaEstadosAnimacion.ESTATICO_IZQUIERDA){
      jugador.setAnimationState(MaquinaEstadosAnimacion.MOV_IZQUIERDA);
    }
  }
  
  /* Disparando y seteando el tiempo de disparo */
  if ((input == 'i' || input == 'j' || input == 'k' || input == 'l') && !jugador.getIsShooting()) {
    gestorBalas.addBullet(jugador.shoot(input));
    jugador.setTimeSinceLastShot(millis());
    jugador.setIsShooting(true);    
  }  
  
  /* Verificando que el jugador mantenga su orientación al disparar mientras se mueve arriba o abajo */
  if (input == 'i' || input == 'k'){
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
  } else if ((estadoJuego == EstadoJuego.VICTORIA || estadoJuego == EstadoJuego.DERROTA) && key == ENTER) {
    estadoJuego = EstadoJuego.MENU;
  }
  
}

void iniciarJuego() {
  estadoJuego = EstadoJuego.JUGANDO;
    // Aqui deberiamos reiniciar el estado del juego
  dungeon = new Dungeon(nivel);
  jugador = new Player(new PVector(width/2, height/2));
   gestorBalas = new GestorBullets();
   gestorEnemigos = new GestorEnemigos();
}

public void keyReleased() {
  switch (Character.toLowerCase(key)) { // convierte la tecla a minuscula 
    case 'w':
      W_PRESSED = false;
      break;
    case 's':
      S_PRESSED = false;
      break;
    case 'a':
      A_PRESSED = false;
      break;
    case 'd':
      D_PRESSED = false;
      break;
  }
  
  if (!A_PRESSED == !S_PRESSED == !W_PRESSED == !D_PRESSED){
    if (jugador.getAnimationState() == MaquinaEstadosAnimacion.MOV_DERECHA){
      jugador.setAnimationState(MaquinaEstadosAnimacion.ESTATICO_DERECHA);
    }
    else if (jugador.getAnimationState() == MaquinaEstadosAnimacion.MOV_IZQUIERDA){
      jugador.setAnimationState(MaquinaEstadosAnimacion.ESTATICO_IZQUIERDA);
    }
  }
}

public void displayPlayerPosition() {
  fill(0);
  textSize(16);
  text("pos: "+jugador.getPosicion(), 10, 20);
}
