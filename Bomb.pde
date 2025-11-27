public class Bomb extends GameObject implements IVisualizable{
  private float radioActual;
  private float radioMaximo;
  private boolean haExplotado = false;
  private int duracionExplosion = 60;
  private Colisionador collider;
  private Player objetivo;

  public Bomb(PVector posicion, Player objetivo) {
    super(posicion, 0, 0);
    this.radioActual = 0;
    this.radioMaximo = 60;
    this.objetivo = objetivo;
    this.collider = new Colisionador(this.posicion, (int)radioActual * 2);
  }

  public void display() {
    if (radioActual < radioMaximo) {
      fill(255, 0, 0, 100);
      circle(posicion.x, posicion.y, radioActual * 2.5);
      radioActual += radioMaximo / duracionExplosion;
      collider.setAncho((int)radioActual * 2); // Actualizar el tamaño del collider
      if (collider.colisionaCon(objetivo.getCollider()) && !objetivo.getIsHit()) {
          objetivo.reducirVida();
          haExplotado = true;
        }
    } else {
      haExplotado = true;
    }
  }

  public void explotar(Player jugador) {
    if (collider.colisionaCon(jugador.collider)  && !jugador.isHit) {
      jugador.reducirVida();
      haExplotado = true;
    }
  }

  public boolean checkCollisionWithPlayer(Player jugador) {
    if (collider.colisionaCon(jugador.collider) && !jugador.isHit) {
      jugador.reducirVida();
      return true;
    }
    return false;
  }
}
