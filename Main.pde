/**Variables Globales--------*/
public boolean W_PRESSED;
public boolean D_PRESSED;
public boolean S_PRESSED;
public boolean A_PRESSED;
public int nivel = 1;

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
  Room roomActual = dungeon.getRoom(jugador.col, jugador.row);
  if (roomActual != null) { // si existe:
    roomActual.display();
    // Verificar colisionescon las puertas
    jugador.checkCollisions(roomActual);
  }
  jugador.display(); 
  jugador.mover();
  
  gestorBalas.updateBullets();
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
