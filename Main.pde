/**Variables Globales--------*/
public boolean W_PRESSED;
public boolean D_PRESSED;
public boolean S_PRESSED;
public boolean A_PRESSED;

private Player jugador;

public void setup()
{
  size(900, 800);
  PFont pixelFont = createFont("pixelFont.ttf", 20);
  textFont(pixelFont);
  
  jugador = new Player(new PVector(width/2, height/2));
}

public void draw()
{
  background(100);
  jugador.display(); 
  jugador.mover();
}

public void keyPressed() {
  switch (key) {
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
  switch (key) {
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
