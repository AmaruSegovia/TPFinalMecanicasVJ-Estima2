class SubBoss extends GameObject {
  PVector posicion;
  float velocidad;
  PVector ultimaPosicionJugador;

  int tiempoEspera = 200;//El tiempo de espera del enemigo antes de comenzar a persegui al jugador
  int tiempoEsperaActual = 0;//El tiempo actual de espera acumulador
  int tiempoPersecucion = 200;//El tiempo el cual el enemigo persigue al jugador

  boolean persiguiendoJugador = false;//Indica si el enemigo esta actualmente persiguiendo al jugador, por defecto esta en falso
  ArrayList<Bomb> bombsList;//ArrayList que servira para la creacion de la bombas

  SubBoss(PVector posicionSubBoss, float velocidadSubBoss) {
    this.posicion = posicionSubBoss;
    this.velocidad = velocidadSubBoss;
    this.ultimaPosicionJugador = new PVector(0, 0);
    this.bombsList = new ArrayList<Bomb>();
  }

  /*METODO PARA ACTUALIZAR LA POSICION DEL ENEMIGO BASADO EN LA POSICION DEL JUGADOR*/
  void actualizarPosicion(PVector posicionJugador) {
    //Si no esta persiguiendo al jugador
    if (persiguiendoJugador == false) {
      tiempoEsperaActual++;//Incrementa el tiempo de espera
      if (tiempoEsperaActual >= tiempoEspera) {
        tiempoEsperaActual = 0;//Reseteamos el contador
        persiguiendoJugador = true;
        ultimaPosicionJugador = posicionJugador.copy();//Actualiza la ultima posicion obtenida del jugador
      }
    }
    /*PERSEGUIR AL JUGADOR*/
    if (persiguiendoJugador == true) {
      PVector direccion = PVector.sub(ultimaPosicionJugador, posicion);//Calculamos la direccion hacia la ultima posicion del jugador
      float distancia = direccion.mag();//Calculamos la distancia a la ultima posicion del jugador
      if (distancia > 9) {
        direccion.normalize();//Normalizamos a la direccion
        direccion.mult(velocidad * Time.getDeltaTime(frameRate));//La multiplicamos para aumentar su velocidad y evitar que avanze a muy poca velocidad
        posicion.add(direccion);//Mueve al subjefe hacia la direccion calculada
        creacionBombas();
        println("Persiguiendo al jugador");
      } else {
        persiguiendoJugador = false;
        println("No esta persiguiendo al jugador");
      }
    }
    if (persiguiendoJugador == false) {
      movimientoOscilatorioY();
    }
  }

  void dibujarSubBoss() {
    fill(#8B08FF);
    circle(this.posicion.x, this.posicion.y, 50);
  }

  /*Creacion de las Bombas*/
  void creacionBombas() {
    
  }
  /*Metodo que crea a las bombas y las elimina*/
  void creacionEliminacionBombas(Player jugador) {
    //Itera en el bucle for la lista bomba desde el ultimo hasta el primero para evitar problemas al eliminar las bombas mientras itera
    for (int i = bombsList.size() - 1; i >= 0; i--) {
      Bomb bomba = bombsList.get(i);
      bomba.dibujar();
      bomba.explotar(jugador);
      //Si la bomba exploto entonces usamos la funcion remove de arraylist para eliminar a la bomba de acuerdo a la posicion
      if (bomba.haExplotado) {
        bombsList.remove(i);
      }
    }
  }

  /*Movimiento Oscilatorio del sub Jefe al detenerse*/
  void movimientoOscilatorioY() {
    int tiempo = millis() / 1000;
    int velocidad = 2;
    int amplitud = 80;//Altura de la oscilacion en el eje Y
    this.posicion.y += (amplitud * sin(tiempo * velocidad) * Time.getDeltaTime(frameRate));
  }
}
