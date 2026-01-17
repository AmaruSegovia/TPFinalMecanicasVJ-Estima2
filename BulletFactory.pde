// Patron de disenio Command para quitar dependencias 
/** Clase que llama a la fabricacion **/
class BulletFactory {
  public Bullet createPlayerBullet(PVector posicion, Direction dir, float damage) {
    return new Bullet(
      posicion.copy(),
      10, 10,
      dir.toVector().normalize(), // dirección fija
      400,
      BulletOwner.PLAYER,
      damage
    );
  }

  public Bullet createEnemyBullet(PVector posicion, PVector target, float damage) {
    PVector direccion = target.copy().sub(posicion).normalize();
    return new Bullet(
      posicion.copy(),
      10, 10,
      direccion,
      300,
      BulletOwner.ENEMY,
      damage
    );
  }
}
