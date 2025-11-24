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
  /** Actuliza el estado del enemigo **/
  @Override
  public void update(Player player, Room room) {
    mover(player,room);
    evitarColisiones(room.getAllEnemies()); // si Room mantiene lista de followers
    updateHitEffect(); // logica comun de impacto
    checkCollisionWithPlayer(player);
    limitarDentroPantalla(70);
  }
  
  /** Dibuj al enemigo */
  @Override
  void display() {
    tint(currentColor);
    noStroke();
    // dibuja al enemigo
    imageMode(CENTER);
    this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(this.posicion.x, this.posicion.y));
    // dibuja el area de colision del enemigo
    this.collider.display(#FF3E78);
    this.collider.setPosicion(this.posicion);

    // Dibujar el contorno de la barra de vida
    noFill();
    stroke(0);
    dibujarBarraVida(6, 40, 5, 30);
  }

  public void mover(Player jugador, Room room) {
    PVector direccion = PVector.sub(jugador.getPosicion(), this.posicion); // calcula la direccion hacia el jugador
    direccion.normalize(); // normaliza la direccion
    direccion.mult(velocidad); // multiplica por la velocidad
    this.posicion.add(direccion); // actualiza la posición del enemigo
  }

  public void evitarColisiones(ArrayList<Enemy> enemies) {
    for (Enemy e : enemies) {
      if (e instanceof Follower && e != this) {
        PVector direccion = PVector.sub(this.posicion, e.getPosicion());
        direccion.normalize();
        direccion.mult(velocidad);
        this.posicion.add(direccion);
      }
    }
  }

}
