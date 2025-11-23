import java.util.Iterator;
import java.util.ArrayList;
/** Clase que administra las balas del juego */
public class GestorBullets {
  /* -- ATRIBUTOS -- */
  /** Define el Array que almacenará las balas */
  private ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  
  /* Se lo quita ya que no sera necesario porquie encontre Iterator :D este si me deja eliminarlo en el recorrido*/
  //private ArrayList<Bullet> removableBullets = new ArrayList<Bullet>();


  /* -- MÉTODOS -- */
  /** Método para agregar balas al array */
  public void addBullet(Bullet bullet) {
    this.bullets.add(bullet);
  }

  /** Método para actualizar el estado de las balas */
 public void update(Room room, Player player) {
   // mover todas las balas
    for (Bullet b : bullets) {
      if (b.getDirection() != null) {
        b.mover();
      } else if (!b.isDisparada()) {
        b.orbitar(room.getPosicion()); // ejemplo: orbitar alrededor del boss
      } else {
        b.moverAng();
      }
    }
    // Coliciones con enemigos
    for (Bullet b : bullets) {
      if (b.getOwner() == BulletOwner.PLAYER) {
        for (Enemy e : room.getAllEnemies()) {
          if (b.getCollider().colisionaCon(e.getCollider())) {
            if (e.getLives() <= 0) room.removeEnemy(e);
          }
        }
      }
    }

    // verificar colisiones con jugador
    for (Bullet b : bullets) {
      if (b.getOwner() == BulletOwner.ENEMY) {
        b.getCollider().colisionaCon(player.getCollider());
      }
    }

      // Fuera de pantalla
      bullets.removeIf(b -> b.balaFuera() );
   
  }
  
  void dibujarBalas() {
    for (Bullet b : bullets) {
      b.display();
    }
  }
  
  void dispararBalas() {
    for (Bullet b : bullets) {
      if (!b.disparada) {
        b.disparar();
      }

    }
  }
  /* mueve las balas del enemigo*/
  void moverBalas(PVector bossPosition) {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet b = bullets.get(i);
      if (!b.disparada) {
        b.orbitar(bossPosition);
      } 
    }
  }
  /** Getters **
  /** Devuelve la cantidad actual de balas activas */
  public int getBulletCount() {
    return bullets.size();
  }
  
  public ArrayList<Bullet> getBulletList() {  return this.bullets;  }
}
