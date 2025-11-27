/** Clase que representa a un vector */
class  Vector {
  /* -- ATRIBUTOS -- */
  /** Representa las coordenadas del origen del vector*/
  private PVector origen;
  /** Representa las coordenadas del destino del vector */
  private PVector destino;
  /** Representa el tamaño de la flecha del vector */
  private Integer tamañoFlecha = 12;

  /* -- CONSTRUCTORES -- */
  /** Constructor por defecto Vector nulo */
  public Vector() {
    this.origen = new PVector(0, 0);
    this.destino = new PVector(0, 0);
  }
  /** Constructor parametrizado, Vector con origen y destino */
  public Vector(PVector origen, PVector destino) {
    this.origen = origen.copy();
    this.destino = destino.copy();
  }
  /** Constructor parametrizado con direccion Predefinida */
  public Vector(PVector origen, Direction  dir) {
    this.origen = origen.copy();
    this.destino = directionToVector(dir,60);
  }

  /* -- METODOS --*/
  /** Metodo que dibuja al vector */
  public void display() {
    strokeWeight(2);
    stroke(#34407E);
    line(this.origen.x, this.origen.y, this.origen.x + this.destino.x, this.origen.y + this.destino.y);

    // Dibujar la flecha al final del vector
    float angle = atan2(this.destino.y, this.destino.x ); //Calcula el angulo entre la linea en radianes.
    strokeWeight(3);
    fill(#34407E);
    pushMatrix(); // Todos los cambios aplicados no afectaran a otros objetos que se dibujen después.
      translate(this.origen.x + this.destino.x, this.origen.y + this.destino.y); // Se traslada el origen del sistema de coordenadas al punto final del vector
      rotate(angle); //Se rota el sistema de coordenadas al ángulo del vector
      triangle(-this.tamañoFlecha, this.tamañoFlecha/2, -this.tamañoFlecha, -this.tamañoFlecha/2, 0, 0);
    popMatrix();
  }

  /** Metodo que suma dos Vectores*/
  public Vector sumar(Vector sumando) {
    return new Vector(this.origen, PVector.add(this.destino, sumando.getDestino()) );
  }

  /** Metodo que devuelve el producto punto de dos vectores*/
  public float obtenerProductoPunto(Vector vector) {
    return PVector.dot(this.destino, vector.getDestino());
  }

  /** Metodo que devuelve la magnitud del vector */
  public float obtenerMagnitud() {
    return this.destino.mag();
  }
  
  public void normalizar(){
    this.destino.normalize();
  }

  /* -- ASESORES -- */
  /* Getters */
  /** Devuelve las coordenadas del punto origen del vector */
  public PVector getOrigen() {
    return this.origen.copy();
  }
  /** Devuelve las coordenadas del punto destino del vector */
  public PVector getDestino() {
    return this.destino.copy();
  }

  /* Setters */
  /** Asigna un nuevo origen al vector */
  public void setOrigen(PVector nuevaPos) {
    this.origen = nuevaPos.copy();
  }
  
  /** Asigna un nuevo destino al vector */
  public void setDestino(PVector nuevaPos) {
    this.destino = nuevaPos.copy();
  }

  /** Asigna un nuevo destino al vector segun el nombre de la direccion*/
  public void setDestino(Direction dir){
    this.destino = directionToVector(dir, 60);
  }
  
  public void setArrowSize(int size) { 
    this.tamañoFlecha = size; 
  }
  
  private PVector directionToVector(Direction dir, int magnitud){
    switch (dir) {
      case UP:    return new PVector(0, -magnitud);
      case DOWN:  return new PVector(0, magnitud);
      case LEFT:  return new PVector(-magnitud, 0);
      case RIGHT: return new PVector(magnitud, 0);
      default: println("No es valido"); return new PVector (0,0);
    }
  }
  
} //end class Vector
