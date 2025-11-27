/** Interfaz que propone el movimiento de los objetos */
interface IMovable {
  /** Contrato para aplicar movimiento */
  abstract public void mover(Player player, GestorEnemigos enemies);
}

/** Enemigos que disparan balas */
interface IShooter {
  void shoot(Player player, GestorBullets gestorBalas);
}
