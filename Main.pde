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
}
