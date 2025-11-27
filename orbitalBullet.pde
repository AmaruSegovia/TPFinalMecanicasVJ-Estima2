class OrbitalBullet extends Bullet {
  private Boss boss;
  private float angulo;
  private float radio;
  private float velocidadOrbita;
  private int tiempoLanzamientoMs;
  private boolean enOrbita;

  public OrbitalBullet(Boss boss, float anguloInicial, float radio, float tiempoOrbitaSeg, float damage) {
    super(boss.getPosicion().copy(), anguloInicial, radio);
    this.boss = boss;
    this.angulo = anguloInicial;
    this.radio = radio;
    this.damage = damage;
    this.velocidadOrbita = 2.0f; // radianes por segundo
    this.tiempoLanzamientoMs = millis() + int(tiempoOrbitaSeg );
    this.enOrbita = true;
    this.spriteBoss = new SpriteObject("bossBullet2.png", ancho, alto, 4);
  }
  
  public void mover() {
    PVector bossPosition = boss.getPosicion();
    if (enOrbita) {

        this.angulo += 0.04; // Velocidad de la orbita

        // Parametros para la oscilación radial
        float baseRadio = 100; // Radio base de la orbita
        float amplitude = 300; // Amplitud de la oscilacion
        float frequency = 0.7; // Frecuencia de la oscilación

        // Calcular la oscilación radial
        float radialOscillation = baseRadio + amplitude * sin(frequency * (millis() / 1000.0));

        // Actualizar la posición de la bala con la oscilación radial
        this.posicion.x = bossPosition.x + radialOscillation * cos(angulo);
        this.posicion.y = bossPosition.y + radialOscillation * sin(angulo);
        colisionador.setPosicion(this.posicion);
        // lanzar despues de cierto tiempo
      if (millis() >= tiempoLanzamientoMs) {
        enOrbita = false;
        this.direction = new PVector(cos(angulo), sin(angulo));
        this.speed = 300;
      }
    
    } else {
      super.mover(); // movimiento normal
    }
  }
}
