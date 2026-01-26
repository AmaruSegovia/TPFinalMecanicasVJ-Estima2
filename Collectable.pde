abstract class Collectible extends GameObject {
  protected Colisionador collider;
  protected boolean picked = false;
  protected String notificationText = "Objeto recogido";

  public Collectible(PVector pos) {
    super(pos, 20, 20);
    collider = new Colisionador(pos, 20);
  }

  public void update(Player p, Notificaciones notifications) {
    collider.display(0);
    collider.setPosicion(posicion);

    if (!picked && collider.colisionaCon(p.getCollider())) {
      onPickUp(p);
      notifications.add(notificationText);
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

    if (r < 0.15) return new EnemyLifeRevealCollectible(pos);
    if (r < 0.35) return new HeartCollectible(pos);
    if (r < 0.55) return new FireRateCollectible(pos);
    if (r < 0.75) return new BulletSpeedCollectible(pos);
    return new BootsCollectible(pos);
  }
}


//------------------ :0 -----------------------
class BootsCollectible extends Collectible {

  public BootsCollectible(PVector pos) {
    super(pos);
    this.notificationText = "MAS VELOCIDAD, MAS VIDA";
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
    this.notificationText = "VIDA EXTRA";
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
    this.notificationText = "OJO REVELADOR";
  }

  void onPickUp(Player p) {
    p.enableEnemyLifeReveal();
  }

  public void display() {
    fill(255, 255, 0);
    rect(posicion.x, posicion.y, ancho, alto);
  }
}

class FireRateCollectible extends Collectible {
  public FireRateCollectible(PVector pos) {
    super(pos);
    this.notificationText = "MAS BALAS";
  }
  void onPickUp(Player p) {
    int current = p.getShootCooldown();
    p.setShootCooldown(max(100, current - 50)); // Reducir cooldown, mínimo 100ms
  }
  void display() {
    fill(200, 100, 255);
    rect(posicion.x, posicion.y, ancho, alto);
  }
}

class BulletSpeedCollectible extends Collectible {
  public BulletSpeedCollectible(PVector pos) {
    super(pos);
    this.notificationText = "MAS VELOCIDAD EN BALAS";
  }
  void onPickUp(Player p) {
    p.setBulletSpeed(p.getBulletSpeed() + 100);
  }
  void display() {
    fill(255, 150, 0);
    triangle(posicion.x, posicion.y + 10, posicion.x - 10, posicion.y - 10, posicion.x + 10, posicion.y - 10);
  }
}
