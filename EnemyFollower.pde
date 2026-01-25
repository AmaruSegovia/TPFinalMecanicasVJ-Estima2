class Follower extends Enemy implements IVisualizable, IMovable{
  /** Representa la velocidad del enemigo */
  private float velocidad;
  
  private Colisionador tempCollider;

  /* -- CONSTRUCTOR -- */
  public Follower(PVector posicion) {
    super(posicion,6,color(255, 255, 255),1); 
    this.ancho=22;
    this.alto=22;
    this.velocidad = 140; // ajusta la velocidad del enemigo
    this.collider = new Colisionador(this.posicion, this.ancho*3);
    this.sprite = new SpriteObject("chaser.png", ancho, alto, 3);
    this.tempCollider = new Colisionador(new PVector(0, 0), this.ancho*3);
  }
  
  /* -- METODOS -- */
  /** Actuliza el estado del enemigo **/
  @Override
  public void update(Player player, GestorEnemigos enemies) {
    mover(player,enemies);
    //evitarColisiones(room.getAllEnemies()); // si Room mantiene lista de followers
    updateHitEffect(); // logica comun de impacto
    checkCollisionWithPlayer(player);
    limitarDentroPantalla(70);
    this.collider.setPosicion(this.posicion);
  }
  
  /** Dibuj al enemigo */
  @Override
  void display() {
    tint(currentColor);
    noStroke();
    // dibuja al enemigo
    imageMode(CENTER);
    this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, this.posicion);
    // dibuja el area de colision del enemigo
    //this.collider.display(#FF3E78);

  }

  public void mover(Player jugador, GestorEnemigos enemies) {
    // dir hacia el jugador
    PVector direccion = PVector.sub(jugador.getPosicion(), this.posicion);
    direccion.normalize();
    direccion.mult(velocidad * Time.getDeltaTime(frameRate));
  
    // posicion tentativa
    PVector nuevaPos = PVector.add(this.posicion, direccion);
  
    // [OPTIMIZACIÓN] Reutilizar colisionador temporal en lugar de crear uno nuevo cada frame
    tempCollider.setPosicion(nuevaPos);
  
    boolean puedeMover = true;
    for (Enemy e : enemies.getAllEnemies()) {
      if (e != this && e instanceof Follower) {
        if (tempCollider.colisionaCon(e.getCollider())) {
          puedeMover = false;
          break;
        }
      }
    }
  
    if (puedeMover) {
      this.posicion.set(nuevaPos);
      this.collider.setPosicion(this.posicion);
    }
  }

}
