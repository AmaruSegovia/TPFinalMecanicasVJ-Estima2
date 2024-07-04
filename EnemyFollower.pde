/* Clase del enemigo que sigue al jugador */
class Follower extends Enemy implements IVisualizable {
  private float velocidad; // velocidad del enemigo

  public Follower(PVector posicion) {
    super(posicion,4); 
    this.velocidad = 2; // ajusta la velocidad del enemigo
  }

  void display() {
    fill(0, 0, 255); // color azul para diferenciar al seguidor
    noStroke();
    circle(posicion.x,  posicion.y, 40);
    fill(255, 0, 0);
        text(lives,this.posicion.x,this.posicion.y);
  }

  public void seguirJugador(Player player) {
    PVector direccion = PVector.sub(player.getPosicion(), this.posicion); // calcula la dirección hacia el jugador
    direccion.normalize(); // normaliza la dirección
    direccion.mult(velocidad); // multiplica por la velocidad

    this.posicion.add(direccion); // actualiza la posición del enemigo
  }
  
  public void evitarColisiones(ArrayList<Follower> followers) {
    for (Follower follower : followers) {
      if (follower != this && colisionarCirculo(this, follower)) {
        PVector direccion = PVector.sub(this.posicion, follower.getPosicion());
        direccion.normalize();
        direccion.mult(velocidad);
        this.posicion.add(direccion);
      }
    }}
    
      private boolean colisionarCirculo(GameObject primero, GameObject segundo) {
    float distancia = PVector.dist(primero.getPosicion(), segundo.getPosicion());
    float radios = primero.getAncho() / 2 + segundo.getAncho() / 2;
    return distancia <= radios;
  }
}
