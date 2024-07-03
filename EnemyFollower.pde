/* Clase del enemigo que sigue al jugador */
class EnemyFollower extends GameObject implements IVisualizable {
  private float velocidad; // velocidad del enemigo

  public EnemyFollower(PVector posicion) {
    super(posicion, 40, 40); // constructor de clase GameObject con la pos y tamaño
    this.velocidad = 2; // ajusta la velocidad del enemigo
  }

  void display() {
    fill(0, 0, 255); // color azul para diferenciar al seguidor
    noStroke();
    circle(posicion.x - ancho / 2,  posicion.y - alto / 2, 40);
  }

  public void seguirJugador(Player player) {
    PVector direccion = PVector.sub(player.getPosicion(), this.posicion); // calcula la dirección hacia el jugador
    direccion.normalize(); // normaliza la dirección
    direccion.mult(velocidad); // multiplica por la velocidad

    this.posicion.add(direccion); // actualiza la posición del enemigo
  }
  
  public void evitarColisiones(ArrayList<EnemyFollower> enemyFollowers) {
    for (EnemyFollower enemyFollower : enemyFollowers) {
      if (enemyFollower != this && colisionarCirculo(this, enemyFollower)) {
        PVector direccion = PVector.sub(this.posicion, enemyFollower.getPosicion());
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
