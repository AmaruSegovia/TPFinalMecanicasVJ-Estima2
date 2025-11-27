/** Clase que gestiona los sprites de los elementos renderizables del juego */
class SpriteObject {
  /* -- ATRIBUTOS -- */
  /** Representa al SpriteSheet del Objeto */
  private PImage spriteSheet;

  /** Representa el Ancho del Frame individual */
  private int anchoFrame;

  /** Representa el Alto del Frame individual */
  private int altoFrame;

  /** Representa la Posición inicial x del Frame */
  private int xFrame;

  /** Representa la Posición inicial y del Frame (contador para animación hacia arriba) */
  private int yFrame;

  /** Representa el Puntero al primer píxel en x de un frame */
  private float punteroXFrame;

  /** Representa el Puntero al primer píxel en x del siguiente frame a punteroXFrame; */
  private float punteroXFrameSiguiente;

  /** Representa la velocidad con la que se reproducirá la animación (la transición entre sprites) */
  private float velocidadAnimacion;
  
  /** Representa la velocidad con la que se reproducirá la animación (la transición entre sprites) */
  private int escala;

  /* -- CONSTRUCTORES -- */

  /** Constructor Parametrizado */
  public SpriteObject(String spriteSheet, int anchoFrame, int altoFrame, int escala) {
    this.spriteSheet = requestImage(spriteSheet);
    this.anchoFrame = anchoFrame;
    this.altoFrame = altoFrame;
    this.xFrame=0;
    this.yFrame=0;
    this.escala=escala;
    this.velocidadAnimacion = 14;
  }


  /* -- MÉTODOS -- */
  /** Diubjando los Sprites segun su estado */
  public void render(int estado, PVector posicion) {
    imageMode(CENTER);
    switch(estado) {
      case MaquinaEstadosAnimacion.MOV_DERECHA:{
       //Colocando la imagen en la fila del Sprite de idle
       this.yFrame = 0;
       //Dibujando el frame
       image(this.spriteSheet.get(this.xFrame, this.yFrame, this.anchoFrame, this.altoFrame), posicion.x, posicion.y, this.anchoFrame * escala, this.altoFrame * escala);
       moverSprite();
       break;
       }
       case MaquinaEstadosAnimacion.MOV_IZQUIERDA:{
       //Colocando la imagen en la fila del Sprite mov abajo
       this.yFrame = this.altoFrame;
       //Dibujando el frame
       image(this.spriteSheet.get(this.xFrame, this.yFrame, this.anchoFrame, this.altoFrame), posicion.x, posicion.y, this.anchoFrame * escala, this.altoFrame * escala);
       moverSprite();
       break;
       }
       case MaquinaEstadosAnimacion.ESTATICO_DERECHA:{
       //Colocando la imagen en la fila del Sprite mov derecha
       this.yFrame = this.altoFrame*2;
       //Dibujando el frame
       image(this.spriteSheet.get(this.xFrame, this.yFrame, this.anchoFrame, this.altoFrame), posicion.x, posicion.y, this.anchoFrame * escala, this.altoFrame * escala);
       moverSprite();
       break;
       }
       case MaquinaEstadosAnimacion.ESTATICO_IZQUIERDA:{
       //Colocando la imagen en la fila del Sprite mov arriba
       this.yFrame = this.altoFrame*3;
       image(this.spriteSheet.get(this.xFrame, this.yFrame, this.anchoFrame, this.altoFrame), posicion.x, posicion.y, this.anchoFrame * escala, this.altoFrame * escala);
       moverSprite();
       break;
       }
       case MaquinaEstadosAnimacion.ATAQUE_DERECHA:{
       //Colocando la imagen en la fila del Sprite mov izquierda
       this.yFrame = this.altoFrame*4;
       image(this.spriteSheet.get(this.xFrame, this.yFrame, this.anchoFrame, this.altoFrame), posicion.x, posicion.y, this.anchoFrame * escala, this.altoFrame * escala);
       moverSprite();
       break;
       }
       case MaquinaEstadosAnimacion.ATAQUE_IZQUIERDA:{
       //Colocando la imagen en la fila del Sprite mov izquierda
       this.yFrame = this.altoFrame*5;
       image(this.spriteSheet.get(this.xFrame, this.yFrame, this.anchoFrame, this.altoFrame), posicion.x, posicion.y, this.anchoFrame * escala, this.altoFrame * escala);
       moverSprite();
       break;
       }
       case MaquinaEstadosAnimacion.MOV_ESPECIAL:{
       //Colocando la imagen en la fila del Sprite mov izquierda
       this.yFrame = this.altoFrame*4;
       image(this.spriteSheet.get(this.xFrame, this.yFrame, this.anchoFrame, this.altoFrame), posicion.x, posicion.y);
       moverSprite();
       break;
       }
       
    }
  }
  public int getXFrame() {
  return this.xFrame;
}
public void renderSimple(PVector posicion) {
  imageMode(CENTER);
  image(this.spriteSheet.get(this.xFrame, this.yFrame, this.anchoFrame, this.altoFrame),
        posicion.x, posicion.y, this.anchoFrame * escala, this.altoFrame * escala);
  moverSprite();
}


  /** Mueve la posicion del Frame en x del SpriteSheet */
  public void moverSprite() {
    this.punteroXFrame += anchoFrame*velocidadAnimacion*Time.getDeltaTime(frameRate);

    if (this.punteroXFrame >= this.punteroXFrameSiguiente) {
      this.xFrame += this.anchoFrame;
      this.punteroXFrameSiguiente = this.xFrame+this.anchoFrame;
      //Reiniciando Punteros para el error de pasos del sprite
      this.punteroXFrame = 0;
      this.punteroXFrameSiguiente = this.anchoFrame;

      //Reiniciando animación al llegar al final del spriteSheet
      if (this.xFrame >= this.spriteSheet.width) {
        this.xFrame = 0;
      }
    }
  }
}
