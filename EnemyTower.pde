class Tower extends Enemy implements IVisualizable {
  private float fireRate;
  private float lastFireTime;
  private ArrayList<Bala> balas;
    
  private SpriteObject sprite;//El objeto sprite del enemigo

  /* -- CONSTRUCTOR --*/
  public Tower(PVector posicion) {
    super(posicion, 2, color(255, 255, 255)); 
    this.ancho=22;
    this.alto=22;
    this.fireRate = 0.5;
    this.lastFireTime = millis() / 1000.0;
    this.balas = new ArrayList<Bala>();
    this.collider = new Colisionador(this.posicion, this.ancho*3);
    this.sprite = new SpriteObject("turret.png", ancho, alto, 3);
  }

  /* -- METODOS -- */
  /** Metodo que dibuja a la Torre */
  public void display() {
    if (isHit) {
      float elapsed = millis() - hitTime;
      if (elapsed < hitDuration) {
        float lerpFactor = elapsed / hitDuration;
        currentColor = lerpColor(color(255, 0, 0), originalColor, lerpFactor);
      } else {
        isHit = false;
        currentColor = originalColor;
      }
    } else {
      currentColor = originalColor;
    }

    tint(currentColor);
    noStroke();
    // dibuja a la torreta
    imageMode(CENTER);
    tint(#FFFFFF);
    this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(this.posicion.x, this.posicion.y));
    //dibuja elarea de colision con la torre
    //this.collider.displayCircle(#DE3EFF);

    for (Bala bala : balas) {
      bala.display();
    }

    dibujarBarraVida(2, 40, 5, 35);
  }

  public void detectar(Player player) {
    PVector centro = new PVector(posicion.x, posicion.y);
    PVector vectorDireccion = PVector.sub(player.posicion, centro);
    float productoPunto = vectorDireccion.dot(vectorDireccion);

    float radioDeteccion = 180;
    float radioDeteccionCuadrado = radioDeteccion * radioDeteccion;

    if (productoPunto <= radioDeteccionCuadrado) {
      float currentTime = millis() / 1000.0f;
      if (currentTime - lastFireTime >= fireRate) {
        Bala nuevaBala = new Bala(centro.x, centro.y, player.posicion);
        balas.add(nuevaBala);
        lastFireTime = currentTime;
      }
    }

    for (int i = balas.size() - 1; i >= 0; i--) {
      Bala b = balas.get(i);
      b.mover();
      if (b.estaFuera()) {
        balas.remove(i);
      }
    }
  }

  public class Bala extends GameObject implements IMovable, IVisualizable {
    private float x, y;
    private float dirX, dirY;
    private float velocidad = 5;
    private SpriteObject sprite;

    Bala(float xInicial, float yInicial, PVector objetivo) {
      this.x = xInicial;
      this.y = yInicial;
      float vectorX = objetivo.x - xInicial;
      float vectorY = objetivo.y - yInicial;
      float magnitud = sqrt(vectorX * vectorX + vectorY * vectorY);
      this.dirX = vectorX / magnitud;
      this.dirY = vectorY / magnitud;
      this.sprite = new SpriteObject("enemyBullet.png", 10, 10, 2);
    }

    public void mover() {
      this.x += this.dirX * this.velocidad;
      this.y += this.dirY * this.velocidad;
    }

    public void display() {
      this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(this.x, this.y));
    }

    public boolean estaFuera() {
      return (x < 0 || x > width || y < 0 || y > height);
    }
  }
}
