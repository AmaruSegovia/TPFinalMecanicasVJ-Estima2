class Follower extends Enemy implements IVisualizable, IMovable{
  /** Representa la velocidad del enemigo */
  private float velocidad;

  /* -- CONSTRUCTOR -- */
  public Follower(PVector posicion) {
    super(posicion,6,color(255, 255, 255)); 
    this.ancho=22;
    this.alto=22;
    this.velocidad = 2; // ajusta la velocidad del enemigo
    this.collider = new Colisionador(this.posicion, this.ancho*3);
    this.sprite = new SpriteObject("chaser.png", ancho, alto, 3);
  }
  
  /* -- METODOS -- */
  /** Dibuj al enemigo */
  void display() {
    //Cambio de color cuando le hacen daño
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
    // dibuja al enemigo
    imageMode(CENTER);
    this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(this.posicion.x, this.posicion.y));
    // dibuja el area de colision del enemigo
    //this.collider.displayCircle(#FF3E78);

  
    // Dibujar el contorno de la barra de vida
    noFill();
    stroke(0);
    
    dibujarBarraVida(6, 40, 5, 30);
  }

  public void mover(InputManager input) {
    PVector direccion = PVector.sub(jugador.getPosicion(), this.posicion); // calcula la dirección hacia el jugador
    direccion.normalize(); // normaliza la dirección
    direccion.mult(velocidad); // multiplica por la velocidad

    this.posicion.add(direccion); // actualiza la posición del enemigo
  }

  public void evitarColisiones(ArrayList<Follower> followers) {
    for (Follower follower : followers) {
      if (follower != this && this.collider.isCircle(follower)) {
        PVector direccion = PVector.sub(this.posicion, follower.getPosicion());
        direccion.normalize();
        direccion.mult(velocidad);
        this.posicion.add(direccion);
      }
    }
  }

}
