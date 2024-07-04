class Boss extends Enemy {
  private boolean inCenter = true;
  protected float speed;
  protected float topSpeed; 
  protected Vector direccion;
  private float tiempoInicio;
  private float tiempoProximoDisparo;  
  private int fase = 1; // Fase del enemigo
  
  // Funciones adicionales para fase 2
  private int tiempoUltimoDisparo;
  private int intervaloDisparo = 2000; // Intervalo de disparo en milisegundos
  private float radioOrbita = 100; // Radio de la órbita

  /* -- CONSTRUCTOR -- */
  public Boss(PVector posicion) {
    super(posicion, 20, color(0, 0, 255));
    this.ancho = 120;
    this.topSpeed= random(150,200);
    this.direccion = new Vector(random(2) < 1 ? "right" : "left");
    this.collider = new Colisionador(this.posicion, this.ancho-40);
    this.tiempoInicio = millis();
    this.tiempoProximoDisparo = millis() + int(random(4000, 6000));
  }
  public void display() {
    noStroke();
    fill(255, 255, 255);
    circle(this.posicion.x, this.posicion.y, this.ancho);
    fill(0);
    text(lives, this.posicion.x, this.posicion.y);
    collider.setPosicion(this.posicion);
    collider.displayCircle(0);
    this.direccion.setOrigen(posicion);
    this.direccion.display();
    
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

    fill(currentColor);
    noStroke();
    
    float barraAncho = 40; // ancho total de la barra
    float barraAlto = 5; // alto de la barra
    float vidasMaximas = 4; // número máximo de vidas
    float anchoActual = (lives / vidasMaximas) * barraAncho; // ancho actual basado en las vidas
  
    fill(255, 0, 0); // color rojo para la barra de vida
    rect(posicion.x - barraAncho / 2, posicion.y - 30, anchoActual, barraAlto); // posición de la barra encima del enemigo
  
    // Dibujar el contorno de la barra de vida
    noFill();
    stroke(0);
    
    dibujarBarraVida(4, 40, 5, 30);
  }
  public void mover() {
    if(lives == 10){
      fase = 2;
    }
    switch (fase) {
    case 1:
      if (inCenter) {
        if (millis() - tiempoInicio > 2000) {
          inCenter = false;
        }
      } else if (!inCenter) {
        moverFase();
        if (millis() > tiempoProximoDisparo) {
          tiempoProximoDisparo = millis() + int(random(3000, 6000));
        }
      }
      break;
      case 2:
        if(!inCenter){
          moverHaciaCentro();
        }
        if (inCenter && millis() - tiempoUltimoDisparo > intervaloDisparo) {
          disparar();
          tiempoUltimoDisparo = millis();
        }
        gestorBalas.moverBalas(this.posicion);
      break;
      default: break;
    }
  }

  public void moverFase() {
    if (this.direccion.obtenerMagnitud() != 0) {
      this.direccion.normalizar();
    }
    this.posicion.add(this.direccion.getDestino().copy().mult(this.topSpeed * Time.getDeltaTime(frameRate)));
    checkCollicionWall();
  }

  public void checkCollicionWall() {
    if ( this.posicion.x < 0 + this.ancho/2 || this.posicion.x > width - this.ancho/2) {
      this.direccion.getDestino().x *= -1;
      resetSpeed();
    }
    
    if (this.posicion.y < 0 || this.posicion.y > height) {
      this.direccion.getDestino().y *= -1;
    }
  }
  public void disparar() {
    switch (fase){
      case 1:
        int numBalas = int(random(4, 8)); // Número aleatorio de balas entre 4 y 7
        for (int i = 0; i < numBalas; i++) {
          float angulo = PI / 2 + radians(40) / (numBalas - 1) * i - radians(20); // Ajustar los ángulos para las balas
          Bullet bala;
          bala = new Bullet(this.posicion.copy(), angulo);
          gestorBalas.addBullet(bala);
        }
      break;
      case 2:
        gestorBalas.dispararBalas();
        for (int i = 0; i < 8; i++) {
          float angulo = TWO_PI / 8 * i;
          Bullet bala = new Bullet(this.posicion.copy(), angulo, radioOrbita);
          gestorBalas.addBullet(bala);
        }
      break;
    }
  }

  public void detectarPlayer(Player player) {
    //area de deteccion dibujada
    noFill();
    stroke(200);
    rect(0, 0, width, 100);

    if (player.getPosicion().y < 100) {
      if (this.posicion.dist(player.getPosicion()) < 1000) {
        fill(255);
        embestir(player);
        checkCollitionPlayer(player);
      }
    }
  }
  public void embestir(Player player) {
    PVector newDireccion = new PVector(player.posicion.x - this.posicion.x, 0).normalize();
    this.topSpeed = 500; // Velocidad de la embestida
    this.direccion.setDestino(newDireccion);
  }

  public void checkCollitionPlayer(Player player) {
    if (collider.isCircle(player)) {
      text("HAY COLICION ", 30, 400);
      if (this.posicion.x - player.posicion.x < 1) {
        this.direccion.setDestino(new PVector(random(2) < 1 ? 1 : -1, 0).normalize());
        resetSpeed();
      }
    }
  }

  public void resetSpeed() {
    this.topSpeed= random(100, 200);
  }
  
  void moverHaciaCentro() {
    PVector centro = new PVector(width / 2, height / 2);
    PVector toCenter = PVector.sub(centro, this.posicion);
    float distancia = toCenter.mag();
    if (distancia > 2) {
      this.direccion.setDestino(toCenter.normalize());
      this.posicion.add(PVector.mult(this.direccion.getDestino(), 160 * Time.getDeltaTime(frameRate) ));
    } else {
      this.setPosicion(centro);
      inCenter = true;
    }
  }
}
