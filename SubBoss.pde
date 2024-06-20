class SubBoss extends GameObject {
  PVector posicion;
  float velocidad;
  PVector ultimaPosicionJugador;

  int tiempoEspera = 200;//El tiempo de espera del enemigo antes de comenzar a persegui al jugador
  int tiempoEsperaActual = 0;//El tiempo actual de espera acumulador
  int tiempoPersecucion = 200;//El tiempo el cual el enemigo persigue al jugador

  boolean persiguiendoJugador = false;//Indica si el enemigo esta actualmente persiguiendo al jugador, por defecto esta en falso

  SubBoss(PVector posicionSubBoss, float velocidadSubBoss) {
    this.posicion = posicionSubBoss;
    this.velocidad = velocidadSubBoss;
    this.ultimaPosicionJugador = new PVector(0, 0);
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
      if (distancia > velocidad) {
        direccion.normalize();//Normalizamos a la direccion
        direccion.mult(velocidad);//La multiplicamos para aumentar su velocidad y evitar que avanze a muy poca velocidad
        posicion.add(direccion);//Mueve al subjefe hacia la direccion calculada
        println("Persiguiendo al jugador");
      } else {
        posicion.set(ultimaPosicionJugador);
        persiguiendoJugador = false;
        println("No esta persiguiendo al jugador");
      }
    }
  }

  void dibujarSubBoss() {
    fill(#FF0505);
    circle(this.posicion.x, this.posicion.y, 50);
  }
}
