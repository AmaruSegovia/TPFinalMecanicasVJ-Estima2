class SubBoss extends Enemy implements IVisualizable, IMovable{
  private float velocidad;
  private PVector ultimaPosicionJugador;
  private int tiempoEspera = 200; // El tiempo de espera del enemigo antes de comenzar a perseguir al jugador
  private int tiempoEsperaActual = 0; // El tiempo actual de espera acumulado
  private boolean persiguiendoJugador = false; // Indica si el enemigo está actualmente persiguiendo al jugador
  //private ArrayList<Bomb> bombsList; // ArrayList que servirá para la creación de las bombas
  private PVector ultimaPosicionBomba; // La posición donde el sub-jefe dejó la última bomba
  private float distanciaBomba = 80; // La distancia que debe cumplir el sub-jefe para dejar otra bomba
  
  /* -- CONSTRUCTOR -- */
  public SubBoss(PVector posicion) {
    super(posicion,10,color(255, 255, 255));
    this.velocidad = 980;   
    this.ancho=22;
    this.alto=22;
    this.ultimaPosicionJugador = new PVector(0, 0);
    //this.bombsList = new ArrayList<Bomb>();
    this.ultimaPosicionBomba = posicion.copy();//La posicion incial del sub-boss
    this.collider = new Colisionador(this.posicion, this.ancho*3);
    this.sprite = new SpriteObject("chaserBoss.png", ancho, alto, 3);
  }

  /** METODO PARA ACTUALIZAR LA POSICION DEL ENEMIGO BASADO EN LA POSICION DEL JUGADOR*/
  public void mover(InputManager input) {
    //Si no esta persiguiendo al jugador
    if (persiguiendoJugador == false) {
      tiempoEsperaActual++;//Incrementa el tiempo de espera
      if (tiempoEsperaActual >= tiempoEspera) {
        tiempoEsperaActual = 0;//Reseteamos el contador
        persiguiendoJugador = true;
        ultimaPosicionJugador = jugador.getPosicion().copy();//Actualiza la ultima posicion obtenida del jugador
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
    if (persiguiendoJugador == false) { // si no lo persigue
      movimientoOscilatorioY();
    }
  }
  /** Metodo que dibuja al subjefe */
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
    // dibuja al boss
    imageMode(CENTER);
    this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(this.posicion.x, this.posicion.y));
    // dibuja la colision del boss
    //this.collider.displayCircle(#FFF63E);
    dibujarBarraVida(10, 50, 5, 35);
  }

  
  /** Creación de las Bombas */
  public void creacionBombas() {
    // Calcula la distancia recorrida desde la última bomba
    float distanciaRecorridaSubBoss = PVector.dist(posicion, ultimaPosicionBomba);
    if (distanciaRecorridaSubBoss >= distanciaBomba) {
      //bombsList.add(new Bomb(posicion.copy()));
      ultimaPosicionBomba = posicion.copy();
    }
  }

  /** Método que crea a las bombas y las elimina */
//  public void creacionEliminacionBombas(Player jugador) {
//  for (int i = bombsList.size() - 1; i >= 0; i--) {
//    Bomb bomba = bombsList.get(i);
//    bomba.display();
//    // Verificar colisión con el jugador y aplicar daño
//    if (bomba.checkCollisionWithPlayer(jugador)) {
//      bomba.explotar(jugador); // Aplica daño al jugador si colisiona
//    }
//    if (bomba.haExplotado) {
//      bombsList.remove(i);
//    }
//  }
//}


  /** Movimiento Oscilatorio del sub Jefe al detenerse*/
  public void movimientoOscilatorioY() {
    int tiempo = millis() / 1000;
    int velocidad = 2;
    int amplitud = 80;//Altura de la oscilacion en el eje Y
    this.posicion.y += (amplitud * sin(tiempo * velocidad) * Time.getDeltaTime(frameRate));
  }
}
