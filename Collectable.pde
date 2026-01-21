abstract class Collectible extends GameObject {
  protected Colisionador collider;
  protected boolean picked = false;

  public Collectible(PVector pos) {
    super(pos, 20, 20);
    collider = new Colisionador(pos, 20);
  }

  public void update(Player p) {
    collider.display(0);
    collider.setPosicion(posicion);

    if (!picked && collider.colisionaCon(p.getCollider())) {
      onPickUp(p);
      picked = true;
    }
  }

  public boolean isPicked() {
    return picked;
  }

  abstract void onPickUp(Player p);
  abstract void display();
}


class CollectibleFactory {
  Collectible randomTreasure(PVector pos) {
    float r = random(1);

    if (r < 0.2) return new EnemyLifeRevealCollectible(pos);
    if (r < 0.5) return new HeartCollectible(pos);
    return new BootsCollectible(pos);
  }
}


//------------------ :0 -----------------------
class BootsCollectible extends Collectible {

  public BootsCollectible(PVector pos) {
    super(pos);
  }

  void onPickUp(Player p) {
    p.setTopSpeed(p.getTopSpeed() + 20);
    p.setLives(p.getLives() + 1);
  }

  void display() {
    fill(0, 200, 255);
    rect(posicion.x, posicion.y, ancho, alto);
  }
}
class HeartCollectible extends Collectible {

  public HeartCollectible(PVector pos) {
    super(pos);
  }

  void onPickUp(Player p) {
    p.setLives(p.getLives() + 1);
  }

  void display() {
    fill(255, 0, 0);
    ellipse(posicion.x, posicion.y, ancho, alto);
  }
}
class EnemyLifeRevealCollectible extends Collectible {

  public EnemyLifeRevealCollectible(PVector pos) {
    super(pos);
  }

  void onPickUp(Player p) {
    p.enableEnemyLifeReveal();
  }

  public void display() {
    fill(255, 255, 0);
    rect(posicion.x, posicion.y, ancho, alto);
  }
}
