/** Clase que administra las balas del juego */
public class GestorBullets {
  /* -- ATRIBUTOS -- */
  /** Define el Array que almacenará las balas */
  private ArrayList<Bullet> bulletList;

  /* -- CONSTRUCTORES -- */
  /** Constructor sin parámetros */
  public GestorBullets() {
    this.bulletList = new ArrayList<Bullet>();
  }

  /* -- MÉTODOS -- */
  /** Método para agregar balas al array */
  public void addBullet(Bullet bullet) {
    this.bulletList.add(bullet);
  }

  /** Método para actualizar el estado de las balas */
  public void updateBullets() {
    ArrayList<Bullet> removableBullets = new ArrayList<Bullet>();
    
    for (Bullet bullet : this.bulletList) {
      bullet.mover();
      bullet.display();

      if (bullet.getPosicion().x >= width || bullet.getPosicion().x <= 0
        || bullet.getPosicion().y >= height || bullet.getPosicion().y <= 0) {
        removableBullets.add(bullet);
      }
    }
    
    this.bulletList.removeAll(removableBullets);
  }
}
