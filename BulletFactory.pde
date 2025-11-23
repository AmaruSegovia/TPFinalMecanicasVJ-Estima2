// Patron de disenio Command para quitar dependencias 
/** Clase que llama a la fabricacion **/
class BulletFactory {
  public Bullet createPlayerBullet(PVector posicion, Direction dir) {
    return new Bullet(
      posicion.copy(),
      10, 10,
      dir.toVector(),
      400
    );
  }

  public Bullet createEnemyBullet(PVector posicion, PVector target) {
    return new Bullet(
      posicion.copy(),
      10, 10,
      target.copy().sub(posicion).normalize(),
      300
    );
  }
}
