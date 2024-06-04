/** Clase Abstracta que representa a todos los Objetos del juego */
abstract class GameObject {
  /* -- ATRIBUTOS -- */
  /** Representa la posición del objeto */
  protected PVector posicion;
  
  /** Representa el ancho (Hitbox) del objeto */
  protected int ancho; 
  
  /** Representa el alto (Hitbox) del objeto */
  protected int alto;
  
  /* -- CONSTRUCTORES -- */
  /** Constructor por Defecto */
  public GameObject(){}
  /** Constructor Parametrizado*/
  public GameObject(PVector posicion, int ancho, int alto){
    this.ancho=ancho;
    this.alto=alto;
    this.posicion=posicion;
  }
  
  /* -- ACCESORES (GETTERS Y SETTERS) -- */
  /* Getters */
  /** Devuelve la posicion del objeto */
  public PVector getPosicion(){
    return this.posicion;
  }
  /** Devuelve el alto del objeto */
  public int getAlto(){
    return this.alto;
  }
  /** Devuelve el ancho del objeto */
  public int getAncho(){
    return this.ancho;
  }
  
  /* Setters */
  /** Cambia la posicion del objeto */
  public void setPosicion(PVector posicion){
    this.posicion=posicion;
  } 
  /** Cambia el alto del objeto */
  public void setAlto(int alto){
    this.alto=alto;
  } 
  /** Cambia el ancho del objeto */
  public void setAncho(int ancho){
    this.ancho=ancho;
  } 
}
