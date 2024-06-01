
public void setup()
{
  size(900,800);
  PFont pixelFont = createFont("pixelFont.ttf", 20);
  textFont(pixelFont);
}

public void draw()
{
   background(#ffffff);
    textSize(50);
      fill(#050000);
      text("Estima2",width/4,height/2);
      fill(#050000,50);
      text("Estima2",width/4+2.5,height/2);
}
