/**Variables Globales--------*/
public boolean W_PRESSED;
public boolean D_PRESSED;
public boolean S_PRESSED;
public boolean A_PRESSED;
public int nivel = 1;

private Room room;
private Player jugador;

public void setup()
{
  size(900, 800);
  PFont pixelFont = createFont("pixelFont.ttf", 20);
  textFont(pixelFont);
  
  jugador = new Player(new PVector(width/2, height/2));
  room = new Room(15,width, height, new PVector(0,0));
}

public void draw()
{
  background(100);
  room.display();
  jugador.display(); 
  jugador.mover();
}

public void keyPressed() {
  switch (Character.toLowerCase(key)) { // convierte la tecla a minuscula 
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
