/** Tipos de colisionadores disponibles */
enum ColliderType {
  CIRCLE,
  RECT
}

/** Clase que verifica las colisiones entre objetos */
class Colisionador{
  private PVector posicion;
  private float ancho;
  private float alto;
  private ColliderType tipo;

  /* -- CONSTRUCTORES -- */
  /** Constructor para circulos */
  public Colisionador(PVector posicion, int ancho) {
    this.posicion = posicion.copy();
    this.ancho = ancho;
    this.alto = ancho;
    this.tipo = ColliderType.CIRCLE;
  }
  /** Constructor para rectangulos */
  public Colisionador(PVector posicion, int ancho, int alto) {
    this.posicion = posicion.copy();
    this.ancho = ancho;
    this.alto = alto;
    this.tipo = ColliderType.RECT;
  }

  /* -- MÉTODOS -- */
  /** Dibuja el area de colision circular*/
  public void display(color c) {
    stroke(c);
    strokeWeight(2);
    noFill();
    if (tipo == ColliderType.CIRCLE) {
      circle(posicion.x, posicion.y, ancho);
    } else {
      rect(posicion.x - ancho/2, posicion.y - alto/2, ancho, alto);
      rect( this.posicion.x, this.posicion.y, this.ancho, this.alto);
    }
  }
  /** Metodo de colision general **/
  public boolean colisionaCon(Colisionador otro) {
    if (this.tipo == ColliderType.CIRCLE && otro.tipo == ColliderType.CIRCLE) {
      return colisionarCirculo(otro);
    }
    if (this.tipo == ColliderType.RECT && otro.tipo == ColliderType.RECT) {
      return colisionarRectangulo(otro);
    }
    if (this.tipo == ColliderType.CIRCLE && otro.tipo == ColliderType.RECT) {
      return colisionarCircRect(this, otro);
    }
    if (this.tipo == ColliderType.RECT && otro.tipo == ColliderType.CIRCLE) {
      return colisionarCircRect(otro, this);
    }
    return false;
  }
  /** Metodo que comprueba la colision entre dos objetos rectangulos */
  public boolean colisionarRectangulo(Colisionador otro) {
    return !(this.getPosicion().x + this.getAncho() < otro.getPosicion().x ||
      this.getPosicion().x > otro.getPosicion().x + otro.getAncho() ||
      this.getPosicion().y + this.getAlto() < otro.getPosicion().y ||
      this.getPosicion().y > otro.getPosicion().y + otro.getAlto());
  }

  /** Metodo que comprueba la colisión entre dos objetos círculares */
  public boolean colisionarCirculo( Colisionador otro) {
    float distancia = PVector.dist(this.posicion, otro.getPosicion());
    float radios = (this.getAncho() + otro.getAncho())/2;
    return distancia <= radios;
  }
  
  /** Metodo que comprueba la colicion de un objeto rectangulo con otro objeto circular */
  public boolean colisionarCircRect(Colisionador circulo, Colisionador rectangulo) {
    // Genera una variable que guarda la posicion(x,y) del circulo, que representara el punto mas cercano entre el rectangulo y el circulo
    PVector point = new PVector(circulo.getPosicion().x, circulo.getPosicion().y);

    // actualiza la posicion X del punto más cercano a los extremos del rectángulo en el eje x, al ancho lo dividimos en 2 porque la imagen esta en el centro
    if (point.x < rectangulo.getPosicion().x - rectangulo.getAncho()/2) {
      point.x = rectangulo.getPosicion().x - rectangulo.getAncho()/2;
    }
    if (point.x > rectangulo.getPosicion().x + rectangulo.getAncho()/2) {
      point.x = rectangulo.getPosicion().x + rectangulo.getAncho()/2;
    }
    // actualiza la posicion Y del punto más cercano a los extremos del rectángulo en el eje y
    if (point.y < rectangulo.getPosicion().y - rectangulo.getAlto()/2) {
      point.y = rectangulo.getPosicion().y - rectangulo.getAlto()/2;
    }
    if (point.y > rectangulo.getPosicion().y + rectangulo.getAlto()/2) {
      point.y = rectangulo.getPosicion().y + rectangulo.getAlto()/2;
    }
    float distance = point.dist(circulo.getPosicion()); //Calcula la distancia entre el punto cercano y la posicion del circulo
    return distance <= circulo.getAncho()/2;
  }
  
  /*  --- Geters ---  */
  public PVector getPosicion(){ return this.posicion.copy(); }
  public float getAncho(){ return this.ancho; }
  public float getAlto(){ return this.alto; }
  
  /* Actualizar posicion */
  public void setPosicion(PVector nuevaPos) {
    this.posicion = nuevaPos.copy();
  }
  /** Actualizar ancho **/
  public void setAncho(float ancho) {
    this.ancho = ancho;
  }
}
