abstract class Collectible extends GameObject {
  int size = 20;

  public Collectible(PVector pos) {
    super(pos, 20, 20);
  }

  public void display() {
    fill(255, 215, 0);
    rect(posicion.x, posicion.y, ancho, alto);
  }

  public boolean checkCollision(Player p) {
    return dist(
      posicion.x, posicion.y,
      p.getPosicion().x, p.getPosicion().y
    ) < 20;
  }

  abstract void onPickUp(Player p, EffectManager manager);
}


//------------------ :0 -----------------------
//class ExtraLife extends Collectible {

//  public ExtraLife(PVector pos) {
//    super(pos, 20, true, 0);
//  }

//  public void apply(Player player) {
//    player.addLife(2);
//  }
//}

class SpeedCollectible extends Collectible {

  public SpeedCollectible(PVector pos) {
    super(pos);
  }

  void onPickUp(Player p, EffectManager manager) {
    manager.addEffect(
      new SpeedBoostEffect(600, 80) // 600 frames ≈ 10 seg
    );
  }

  public void display() {
    fill(0, 200, 255);
    ellipse(posicion.x, posicion.y, 20, 20);
  }
}
