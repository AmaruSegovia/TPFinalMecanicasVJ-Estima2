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
 public void updateBullets(Room room) {
    ArrayList<Bullet> removableBullets = new ArrayList<Bullet>();

    for (Bullet bullet : this.bulletList) {
      bullet.mover();
      if (bullet.pertenece != "jugador"){
        bullet.moverAng();
      }
      bullet.display();

      for (Enemy enemigo : room.getAllEnemies()) {
        if (bullet.verificarColision(enemigo)) {
          removableBullets.add(bullet);
          if(enemigo.lives <= 0){
           room.removeEnemy(enemigo);
          }
          break;
        }
      }

      if (bullet.getPosicion().x >= width || bullet.getPosicion().x <= 0
        || bullet.getPosicion().y >= height || bullet.getPosicion().y <= 0) {
        removableBullets.add(bullet);
      }
    }
    
    this.bulletList.removeAll(removableBullets);
  }
  
  void dibujarBalas() {
    for (Bullet b : bulletList) {
      b.display();
    }
  }
  
  void dispararBalas() {
    for (Bullet b : bulletList) {
      if (!b.disparada) {
        b.disparar();
      }
    }
  }
  /* mueve las balas del enemigo*/
  void moverBalas(PVector bossPosition) {
    for (int i = bulletList.size() - 1; i >= 0; i--) {
      Bullet b = bulletList.get(i);
      if (!b.disparada) {
        b.orbitar(bossPosition);
      }
    }
  }
}
