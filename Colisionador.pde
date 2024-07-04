/** Clase que verifica las colisiones entre objetos */
class Colisionador extends GameObject{

  /* -- CONSTRUCTORES -- */
  /** Constructor para circulos y cuadrados */
  public Colisionador(PVector posicion, int ancho) {
    super(posicion, ancho, ancho);
  }
  /** Constructor para circulos y cuadrados */
  public Colisionador(PVector posicion, int ancho, int alto) {
    super(posicion, ancho, alto);
  }

  /* -- MÉTODOS -- */
  /** Dibuja el area de colision circular*/
  public void displayCircle(color Color) {
    stroke(Color);
    strokeWeight(2);
    noFill();
    circle( this.posicion.x, this.posicion.y, this.ancho);
  }
  /** Dibuja el area de colision rect */
  public void displayRect(color Color) {
    stroke(Color);
    strokeWeight(2);
    noFill();
    rect( this.posicion.x, this.posicion.y, this.ancho, this.alto);
  }
  /** Metodo que comprueba la colision entre dos objetos rectangulos */
  public boolean colisionarRectangulo(GameObject primero, GameObject segundo) {
    return !(primero.getPosicion().x + primero.getAncho() < segundo.getPosicion().x ||
      primero.getPosicion().x > segundo.getPosicion().x + segundo.getAncho() ||
      primero.getPosicion().y + primero.getAlto() < segundo.getPosicion().y ||
      primero.getPosicion().y > segundo.getPosicion().y + segundo.getAlto());
  }

  /** Metodo que comprueba la colisión entre dos objetos círculares */
  public boolean colisionarCirculo(GameObject primero, GameObject segundo) {
    float distancia = PVector.dist(primero.getPosicion(), segundo.getPosicion());
    float radios = primero.getAncho()/2+segundo.getAncho()/2;
    return distancia <= radios;
  }
  
  /** Metodo que comprueba la colisión entre ente colisionador y otro objeto */
  public boolean isCircle( GameObject segundo) {
    float distancia = PVector.dist(this.getPosicion(), segundo.getPosicion());
    float radios = (this.getAncho()+segundo.getAncho())/2;
    return distancia <= radios;
  }
  
  /** Metodo que comprueba la colicion de un objeto rectangulo con otro objeto circular */
  public boolean colisionarCircRect(GameObject circulo, GameObject rectangulo) {
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
}
