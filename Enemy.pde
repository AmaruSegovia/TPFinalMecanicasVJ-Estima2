class Enemy extends GameObject implements IVisualizable {
  private Player target;
  private GestorBullets gestorBalas;
  private float fireRate;
  private float lastFireTime;

  public Enemy(PVector posicion, Player target, GestorBullets gestorBalas) {
    super(posicion, 40, 40);
    this.target = target;
    this.gestorBalas = gestorBalas;
    this.fireRate = 1.0; // Dispara una vez por segundo
    this.lastFireTime = millis() / 1000.0;
  }

  public void display() {
    fill(255, 0, 0);
    noStroke();
    rect(posicion.x - ancho / 2, posicion.y - alto / 2, ancho, alto);
    shootAtPlayer();
  }

  private void shootAtPlayer() {
    float currentTime = millis() / 1000.0;
    if (currentTime - lastFireTime >= 1 / fireRate) {
      PVector direction = PVector.sub(target.getPosicion(), this.posicion).normalize();
      Bullet bullet = new Bullet(this.posicion.copy(), 10, 10, direction, 300);
      gestorBalas.addBullet(bullet);
      lastFireTime = currentTime;
    }
  }
}
