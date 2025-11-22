public class Bala extends GameObject implements IVisualizable, IMovable {
  private float dirX, dirY;
  private float velocidad = 5;
  private SpriteObject sprite;
  private Colisionador collider;

  public Bala(float xInicial, float yInicial, PVector objetivo) {
    super(new PVector(xInicial, yInicial), 10, 10); // Ajustamos el constructor de GameObject
    float vectorX = objetivo.x - xInicial;
    float vectorY = objetivo.y - yInicial;
    float magnitud = sqrt(vectorX * vectorX + vectorY * vectorY);
    this.dirX = vectorX / magnitud;
    this.dirY = vectorY / magnitud;
    this.sprite = new SpriteObject("enemyBullet.png", 10, 10, 2);
    this.collider = new Colisionador(this.posicion, this.ancho);
  }

  public void mover(InputManager input) {
    this.posicion.x += this.dirX * this.velocidad;
    this.posicion.y += this.dirY * this.velocidad;
  }

  public void display() {
    this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, this.posicion);
  }

  public boolean estaFuera() {
    return (posicion.x < 0 || posicion.x > width || posicion.y < 0 || posicion.y > height);
  }
  
   public boolean checkCollisionWithPlayer(Player player) {
    if (collider.isCircle(player.collider) && !player.isHit) {
      player.reducirVida();
      return true;
    }
    return false;
  }
  
}
