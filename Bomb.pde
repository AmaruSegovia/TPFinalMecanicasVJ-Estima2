class Bomb {
  PVector posicion;//Posicion de la bomba
  float radioActual;//El radio actual de la bomba
  float radioMaximo;//El radio maximo de la bomba
  boolean haExplotado = false;//Nos va a indicar si la bomba a explotado o no
  int duracionExplosion = 60;//La duracion de la bomba

  /*Contructor parametrizado*/
  Bomb(PVector posicion) {
    this.posicion = posicion;
    this.radioActual = 0;
    this.radioMaximo = 60;//El tamanio maximo que alcanzara la bomba
  }

  /*Creacion de la explosion*/
  void dibujar() {
    if (radioActual < radioMaximo) {
      fill(255, 0, 0, 100);
      //Dibuja la explosion y expandimo el diametro por 2.5
      circle(posicion.x, posicion.y, radioActual * 2.5);
      //Calcula el crecimiento del radio de la bomba, dividiendo por su duracion de la explosion para saber cuanto debe aumentar el radio en cada frame
      //El radio actual se incrementa por cada interacion, haciendo que la bomba se expanda se expanda hasta su radio maximo
      radioActual += radioMaximo / duracionExplosion;
    } else {
      //Se ejecuta cuando el radio de la bomba alcanzo su maximo expancion
      haExplotado = true;
    }
  }
  /*Explosion de la bomba y afectar al jugador*/
  void explotar(Player jugador) {
    //Comparamos la posicion del jugador y bomba con el radio actual, si es menor que el radio actual, entonces exploto cerca del jugador
    if (dist(posicion.x, posicion.y, jugador.posicion.x, jugador.posicion.y) < radioActual) {
      haExplotado = true;
    }
  }
}
