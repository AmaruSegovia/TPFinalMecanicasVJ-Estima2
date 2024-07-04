class SubBoss extends Enemy implements IVisualizable{
  float velocidad;
  PVector ultimaPosicionJugador;

  int tiempoEspera = 200;//El tiempo de espera del enemigo antes de comenzar a persegui al jugador
  int tiempoEsperaActual = 0;//El tiempo actual de espera acumulador
  int tiempoPersecucion = 200;//El tiempo el cual el enemigo persigue al jugador

  boolean persiguiendoJugador = false;//Indica si el enemigo esta actualmente persiguiendo al jugador, por defecto esta en falso
  ArrayList<Bomb> bombsList;//ArrayList que servira para la creacion de la bombas

  PVector ultimaPosicionBomba;//La posicion donde el sub-jefe dejo la ultima bomba
  float distanciaBomba = 80;//La distancia que debe cumplir el sub-jefe para dejar otra bomba
  SubBoss(PVector posicion) {
    super(posicion,10,color(139, 8, 255));
    this.velocidad = 980;
    this.ultimaPosicionJugador = new PVector(0, 0);
    this.bombsList = new ArrayList<Bomb>();
    this.ultimaPosicionBomba = posicion.copy();//La posicion incial del sub-boss
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
      }
    }
    if (persiguiendoJugador == false) {
      movimientoOscilatorioY();
      println("No esta persiguiendo al jugador");
    }
  }

  void display() {
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

    fill(currentColor);
    noStroke();
    circle(this.posicion.x, this.posicion.y, 50);
    dibujarBarraVida(10, 50, 5, 35);
  }

  /*Creacion de las Bombas*/
  void creacionBombas() {
    //Calcula la distancia recorrida desde la ultima bomba
    float distanciaRecorridaSubBoss = PVector.dist(posicion, ultimaPosicionBomba);
    if(distanciaRecorridaSubBoss >= distanciaBomba){
      bombsList.add(new Bomb(posicion.copy()));
      //actualizamos la posicion en que el sub-jefe creo la ultima bomba
      ultimaPosicionBomba = posicion.copy();
    }
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
