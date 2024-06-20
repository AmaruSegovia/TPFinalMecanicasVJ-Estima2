/**Variables Globales--------*/
public boolean W_PRESSED;
public boolean D_PRESSED;
public boolean S_PRESSED;
public boolean A_PRESSED;
public int nivel = 1;
public int estadoJuego = 0;

private Dungeon dungeon;
private Player jugador;
private GestorBullets gestorBalas;

public void setup()
{
  size(900, 800);
  PFont pixelFont = createFont("pixelFont.ttf", 20);
  textFont(pixelFont);
  dungeon = new Dungeon(nivel);
  jugador = new Player(new PVector(width/2, height/2));
  gestorBalas = new GestorBullets();
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
  Room roomActual = dungeon.getRoom(jugador.col, jugador.row);
  println(jugador.row);
  if (roomActual != null) { // si existe:
    roomActual.display();
    // Verificar colisionescon las puertas
    jugador.checkCollisions(roomActual);
  }
  jugador.display();
  jugador.mover();
  gestorBalas.updateBullets();

  if (jugadorGana()) {
    estadoJuego = EstadoJuego.VICTORIA;
  } else if (jugadorPierde()) {
    estadoJuego = EstadoJuego.DERROTA;
  }
}

void mostrarMenu() {
  background(0, 0, 128);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("MENU PRINCIPAL", width / 2, height / 2 - 40);
  textSize(16);
  text("Presiona ENTER para jugar", width / 2, height / 2);
}

void mostrarVictoria() {
  background(0, 128, 0);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("¡VICTORIA!", width / 2, height / 2 - 40);
  textSize(16);
  text("Presiona ENTER para volver al menú", width / 2, height / 2);
}

void mostrarDerrota() {
  background(128, 0, 0);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("DERROTA", width / 2, height / 2 - 40);
  textSize(16);
  text("Presiona ENTER para volver al menú", width / 2, height / 2);
}

boolean jugadorGana() {
  // Comprueba si la fila del jugador es 1
  if (jugador.row == 1) {
    return true;
  }
  return false;
}

boolean jugadorPierde() {
  // Comprueba si la columna del jugador es 2
  if (jugador.col == 2) {
    return true;
  }
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
    A_PRESSED = true;
    break;
  case 'd':
    D_PRESSED = true;
    break;
  }

  if (input == 'i' || input == 'j' || input == 'k' || input == 'l') {
    gestorBalas.addBullet(jugador.shoot(input));
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
}

public void displayPlayerPosition() {
  fill(0);
  textSize(16);
  text("pos: "+jugador.getPosicion(), 10, 20);
}
