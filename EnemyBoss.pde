class Boss extends Enemy implements IVisualizable, IShooter{ //<>//
  private Direction dirX; 
  private boolean embistiendo = false;
  private boolean inCenter = true;
  protected float speed;
  protected float topSpeed; 
  protected Vector direccion;
  private float tiempoInicio;
  private float tiempoProximoDisparo;  
  private int fase = 1; // Fase del enemigo
  private float damage = 2f;
  
  // Funciones adicionales para fase 2
  private int tiempoUltimoDisparo;
  private int intervaloDisparo = 1200; // Intervalo de disparo en milisegundos
  private float radioOrbita = 150; // Radio de la orbita
  private float baseY; // posicion base en Y cuando llega al centro

  
  private int maxLives = 60;
  
  /* -- CONSTRUCTOR -- */
  public Boss(PVector posicion) {
    super(posicion, 60, color(0, 0, 255), 2);
    this.ancho = 41; //valores del sprite sheet no tocar
    this.alto = 38; //valores del sprite sheet no tocar
    this.topSpeed= random(150,200);
    this.damage = 2;
    
    this.dirX = random(1) < 0.5 ? Direction.LEFT : Direction.RIGHT;
    
    this.collider = new Colisionador(this.posicion, this.ancho*4);
    this.sprite = new SpriteObject("jefe.png", ancho, alto, 4);
    this.tiempoInicio = millis();
    this.tiempoProximoDisparo = millis() + int(random(2000, 5000));
  }
  @Override
  public void update(Player player, GestorEnemigos enemies){
    mover(player);
    checkCollisionWithPlayer(player);
    collider.setPosicion(this.posicion);
  }
  @Override
  public void display() {
    this.sprite.render(MaquinaEstadosAnimacion.MOV_DERECHA, this.posicion.copy());
    
    updateHitEffect();
    lifeBar.drawBoss(this.lives, this.maxLives);
  }

  private void moverHorizontal() {
    // obtener vector de la direccion actual
    PVector movimiento = dirX.toVector().mult(this.topSpeed * Time.getDeltaTime(frameRate));
    this.posicion.add(movimiento);

    // rebote en los bordes
    if (this.posicion.x <= this.ancho/2) {
      this.posicion.x = this.ancho/2;
      dirX = Direction.RIGHT; // rebote hacia derecha
    }
    if (this.posicion.x >= width - this.ancho/2) {
      this.posicion.x = width - this.ancho/2;
      dirX = Direction.LEFT; // rebote hacia izquierda
    }
  }
  private void iniciarEmbestida(Player player) {
    embistiendo = true;
    topSpeed = 800; // velocidad maxima
    dirX = (player.getPosicion().x > this.posicion.x) ? Direction.RIGHT : Direction.LEFT;
  }

  private void moverEmbestida() {
    PVector movimiento = dirX.toVector().mult(topSpeed * Time.getDeltaTime(frameRate));
    this.posicion.add(movimiento);

    // cuando rebota termina la embestida
    if (this.posicion.x <= this.ancho/2) {
      this.posicion.x = this.ancho/2;
      terminarEmbestida();
    }
    if (this.posicion.x >= width - this.ancho/2) {
      this.posicion.x = width - this.ancho/2;
      terminarEmbestida();
    }
  }
  
  private void terminarEmbestida() {
    embistiendo = false;
    topSpeed = random(150,200); // velocidad normal
    dirX = random(1) < 0.5 ? Direction.LEFT : Direction.RIGHT;
  }
  
  /* =========================
     MOVIMIENTO
  ========================== */
  public void mover(Player player) {
    if (lives <= maxLives / 2) {
      fase = 2;
    }

    switch (fase) {
      case 1:
            if (embistiendo) {
              moverEmbestida();
            } else {
              moverHorizontal();
              detectarPlayer(player);
            }
            moverFase1();
        break;
      case 2: moverFase2(); break;
    }
  }

  private void moverFase1() {
    if (inCenter) {
      if (millis() - tiempoInicio > 2000) {
        inCenter = false;
      }
    } else {
    }
  }

  private void moverFase2() {
    if (!inCenter) {
      moverHaciaCentro();
    }else{
      movimientoOscilatorioY();
    }
    
  }
  
  /* =========================
     ATAQUES
  ========================== */
  public void shoot(Player player, GestorBullets gestorBalas) {
    switch (fase) {
      case 1: disparoFase1(gestorBalas); break;
      case 2: disparoFase2(gestorBalas); break;
    }
  }
  private void disparoFase1(GestorBullets gestorBalas) {
    if (millis() > tiempoProximoDisparo) {
       tiempoProximoDisparo = millis() + int(random(1000, 2000));
       int numBalas = int(random(4, 7)); // Número aleatorio de balas entre 4 y 7
       for (int i = 0; i < numBalas; i++) {
         float angulo = PI / 2 + radians(40) / (numBalas - 1) * i - radians(20); // Ajustar los ángulos para las balas
         PVector direccion = new PVector(cos(angulo), sin(angulo));
           Bullet bala = new Bullet(
                new PVector(this.posicion.x, this.posicion.y+65),
                8, 8,
                direccion,
                300,
                BulletOwner.ENEMY,
                this.damage
            );
          gestorBalas.addBullet(bala);
        }
     }
  }
  private void disparoFase2(GestorBullets gestorBalas) {
    if (inCenter && millis() - tiempoUltimoDisparo > intervaloDisparo) {
      tiempoUltimoDisparo = millis();
      int n = 8;
      for (int i = 0; i < n; i++) {
        float angulo = TWO_PI / n * i;
          // mitad de las balas orbitan
          OrbitalBullet orb = new OrbitalBullet(this, angulo, radioOrbita, intervaloDisparo, this.damage); // radio 60px, orbita 2s
          gestorBalas.addBullet(orb);
      }
    }
  }
  /* =========================
     DETECCION DEL JUGADOR
  ========================== */ //<>//
  public void detectarPlayer(Player player) {
    //area de deteccion dibujada
    if (player.getPosicion().y < 160) {
      if (this.posicion.dist(player.getPosicion()) < 1000) {
        fill(255);
        iniciarEmbestida(player);
        //checkCollitionPlayer(player);
      }
    }
  }
  
  public void moverHaciaCentro() {
    PVector centro = new PVector(width / 2, height / 2);
    PVector toCenter = PVector.sub(centro, this.posicion);
    float distancia = toCenter.mag();
    if (distancia > 2) {
      toCenter.normalize();
      this.posicion.add(PVector.mult(toCenter, 160 * Time.getDeltaTime(frameRate) ));
    } else {
      this.setPosicion(centro);
      inCenter = true;
      baseY = centro.y; // guardar la posicion base en Y
      dirX = Direction.RIGHT; // opcional: direccion horizontal
    }
  }
  
  private void movimientoOscilatorioY() {
    float tiempo = millis() / 1000.0f;
    float velocidadOscilacion = 2.0f;   // frecuencia de la oscilacion
    float amplitud = 40;                // altura de la oscilacion

    // posicion Y oscilando alrededor de baseY
    this.posicion.y = baseY + amplitud * sin(tiempo * velocidadOscilacion);
}

  private void resetSpeed() {
    this.topSpeed = random(100, 200);
  }
  
  public boolean isDefeated() {
    return lives <= 0;
  }

}
