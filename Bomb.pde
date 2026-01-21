public class Bomb extends GameObject implements IVisualizable {
  private float radioActual;
  private float radioMaximo;
  public boolean haExplotado = false;
  public boolean animacionTerminada = false;
  private int duracionExplosion = 60;
  private Colisionador collider;
  private Player objetivo;

  // usar spriteobject en vez de animacion manual
  private SpriteObject spriteExplosion;

  public Bomb(PVector posicion, Player objetivo) {
    super(posicion, 0, 0);
    this.radioActual = 0;
    this.radioMaximo = 60;
    this.objetivo = objetivo;
    this.collider = new Colisionador(this.posicion, (int)radioActual * 2);

    // ancho y alto de 1 frame de la explosion
    spriteExplosion = new SpriteObject("explosion.png", 128, 128, 1);
  }

  public void display() {

    // fase de expansion (sin dibujo)
    if (!haExplotado) {
      if (radioActual < radioMaximo) {
        radioActual += radioMaximo / duracionExplosion;
        collider.setAncho((int)radioActual * 2);

        if (collider.colisionaCon(objetivo.getCollider()) && !objetivo.getIsHit()) {
          objetivo.receiveDamage();
          activarAnimacion();
        }
      } else {
        activarAnimacion();
      }
    }

    // fase de animacion
    else if (!animacionTerminada) {
      imageMode(CENTER);

      float tamaño = radioActual * 2.5f;
      if (tamaño <= 0) tamaño = 128;

      // dibuja el sprite con la animacion del spriteobject
      spriteExplosion.renderSimple(posicion);

      // cuando termine el recorrido del spritesheet cerramos la animacion
      if (spriteExplosion.getXFrame() == 0 && haExplotado) {
        animacionTerminada = true;
      }
    }
  }

  private void activarAnimacion() {
    haExplotado = true;
    spriteExplosion.xFrame = 0; // reset manual
  }

  public void explotar(Player jugador) {
    if (collider.colisionaCon(jugador.collider) && !jugador.isHit) {
      jugador.receiveDamage();
      activarAnimacion();
    }
  }

  public boolean checkCollisionWithPlayer(Player jugador) {
    if (collider.colisionaCon(jugador.collider) && !jugador.isHit) {
      jugador.receiveDamage();
      activarAnimacion();
      return true;
    }
    return false;
  }
}
