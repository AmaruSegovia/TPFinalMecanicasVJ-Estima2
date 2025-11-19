class Boss extends Enemy implements IVisualizable, IMovable{ //<>// //<>//
  private boolean inCenter = true;
  protected float speed;
  protected float topSpeed; 
  protected Vector direccion;
  private float tiempoInicio;
  private float tiempoProximoDisparo;  
  private int fase = 1; // Fase del enemigo
  
  // Funciones adicionales para fase 2
  private int tiempoUltimoDisparo;
  private int intervaloDisparo = 1200; // Intervalo de disparo en milisegundos
  private float radioOrbita = 150; // Radio de la órbita
  
  /* -- CONSTRUCTOR -- */
  public Boss(PVector posicion) {
    super(posicion, 60, color(0, 0, 255));
    this.ancho = 41; //valores del sprite sheet no tocar
    this.alto = 38; //valores del sprite sheet no tocar
    this.topSpeed= random(150,200);
    this.direccion = new Vector(random(2) < 1 ? "right" : "left");
    this.collider = new Colisionador(this.posicion, this.ancho*4);
    this.sprite = new SpriteObject("jefe.png", ancho, alto, 4);
    this.tiempoInicio = millis();
    this.tiempoProximoDisparo = millis() + int(random(4000, 6000));
  }
  public void display() {
  noStroke();
  this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, new PVector(this.posicion.x, this.posicion.y));
  collider.setPosicion(this.posicion);
  this.direccion.setOrigen(posicion);
  
  // Cambio de color cuando le hacen daño
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
  
  float margen = 50; // margen en ambos extremos de la pantalla
  float barraAncho = width - 2 * margen; // ancho total de la barra
  float barraAlto = 20; // alto de la barra
  float vidasMaximas = 60; // número máximo de vidas
  float anchoActual = (lives / vidasMaximas) * barraAncho; // ancho actual basado en las vidas
  float r = map(lives, 0, vidasMaximas, 255, 0);
  float g = map(lives, 0, vidasMaximas, 0, 255);
  fill(r, g, 0); // color interpolado para la barra de vida
  rect(margen, height - barraAlto - 80, anchoActual, barraAlto); // posición de la barra en la parte inferior

  // Dibujar el contorno de la barra de vida
  noFill();
  stroke(0);
  strokeWeight(7);
  rect(margen, height - barraAlto - 80, barraAncho, barraAlto);
  strokeWeight(0);
  noFill();
}

  
  public void mover() {
    if(lives <= 30){
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
          disparar();
          tiempoProximoDisparo = millis() + int(random(1000, 1500));
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
        int numBalas = int(random(4, 7)); // Número aleatorio de balas entre 4 y 7
        for (int i = 0; i < numBalas; i++) {
          float angulo = PI / 2 + radians(40) / (numBalas - 1) * i - radians(20); // Ajustar los ángulos para las balas
          Bullet bala;
          bala = new Bullet(new PVector(this.posicion.copy().x, this.posicion.copy().y-60), angulo,"enemigo");
          gestorBalas.addBullet(bala);
        }
      break;
      case 2:
        gestorBalas.dispararBalas();
        
        for (int i = 0; i < 8; i++) {
          float angulo = TWO_PI / 8 * i;
          Bullet bala = new Bullet(this.posicion.copy(), angulo, radioOrbita,"enemigo");
          gestorBalas.addBullet(bala);
           //<>// //<>//
        } //<>// //<>//
      break;
    } //<>// //<>//
  }

  public void detectarPlayer(Player player) {
    //area de deteccion dibujada
    noFill();
    stroke(200);

    if (player.getPosicion().y < 160) {
      if (this.posicion.dist(player.getPosicion()) < 1000) {
        fill(255);
        embestir(player);
        checkCollitionPlayer(player);
      }
    }
  }
  public void embestir(Player player) {
    PVector newDireccion = new PVector(player.posicion.x - this.posicion.x, 0).normalize();
    this.topSpeed = 400; // Velocidad de la embestida
    this.direccion.setDestino(newDireccion);
  }

  public void checkCollitionPlayer(Player player) {
    if (collider.isCircle(player)) {
      
      if (this.posicion.x - player.posicion.x < 1) {
        this.direccion.setDestino(new PVector(random(2) < 1 ? 1 : -1, 0).normalize());
        resetSpeed();
      }
    }
  }

  public void resetSpeed() {
    this.topSpeed= random(100, 200);
  }
  
  public void moverHaciaCentro() {
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
