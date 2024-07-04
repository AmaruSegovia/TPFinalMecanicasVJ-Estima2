/*Clase del enemigo tipo torreta*/
class Tower extends Enemy implements IVisualizable {
  /*atributos de la clase*/
  private float fireRate;
  private float lastFireTime;
  private ArrayList<Bala>balas;
/*-_--__-_-CONSTRUCTOR_-_-_-_-------___*/
  public Tower(PVector posicion) {
    super(posicion,2,color(255, 255, 0));/*constructor de clase gameobj con la pos y tamaño*/
    this.fireRate = 0.5;/*disparos a una bala por medio seg*/
    this.lastFireTime = millis() / 1000.0;
    this.balas=new ArrayList<Bala>();/*array de las balas*/
  }
/*metodo que dibuja la torreta*/
  public void display() {
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
    
    
    noStroke();
    rect(posicion.x - ancho / 2, posicion.y - alto / 2, ancho, alto);
    /*dibuja las balas para el array*/
    for (Bala bala : balas) {
      bala.dibujar();/*metodo que dibuja las balas*/
    }

    fill(0, 0, 255);
    dibujarBarraVida(2, 40, 5, 35);
  }
/***METODO PARA DETECTAR AL PJ DENTRO DEL RADIO MEDIANTE EL PRODUCTO PUNTO***/
  public void detectar(Player player) {
    PVector centro = new PVector(posicion.x, posicion.y);//centro de la torreta
    PVector vectorDireccion = PVector.sub(player.posicion, centro);//vector de la torreta hasta el pj
      /*.-.-.-.-PRDUCTO PUNTO-.-.-.-.-.*/ 
    float productoPunto = vectorDireccion.dot(vectorDireccion);

    float radioDeteccion = 180;//radio de deteccion de la torreta
    float radioDeteccionCuadrado = radioDeteccion * radioDeteccion;//cuadrao del radio

    if (productoPunto <= radioDeteccionCuadrado) {
      float currentTime = millis() / 1000.0f;//dependiendo de este tiempo se crea una nueva bala
      if (currentTime - lastFireTime >= fireRate) {
        Bala nuevaBala = new Bala(centro.x, centro.y, player.posicion);
        balas.add(nuevaBala);//añade bala al array
        lastFireTime = currentTime;//actualiza el tiempo desde la ultima bala
      }
    }

    /* Actualizar y dibujar las balas*/
    for (int i = balas.size() - 1; i >= 0; i--) {
      Bala b = balas.get(i);
      b.actualizar();
      if (b.estaFuera()) {
        balas.remove(i); /* Eliminar las balas que estén fuera del lienzo si esta fuera del lienzo*/
      }
    }
  }

/*la maldita clase bala*/
  class Bala {
    private float x, y;//pos
    private float dirX, dirY;//direcc de la bala
    private float velocidad = 5;//velociti de la bala

    Bala(float xInicial, float yInicial, PVector objetivo) {
      x = xInicial;
      y = yInicial;
/***CALCULO DEL VECTOR DIRRECCION DESDE LA POS INICIAL HASTA EL PJ***/
      float vectorX = objetivo.x - xInicial;
      float vectorY = objetivo.y - yInicial;
      float magnitud = sqrt(vectorX * vectorX + vectorY * vectorY);//magnitud del vector
      /*normalizacion de ambos vectores direccion*/
      dirX = vectorX / magnitud;
      dirY = vectorY / magnitud;
    }
/*metodo que actualiza la pos de la bala*/
    void actualizar() {
      x += dirX * velocidad;
      y += dirY * velocidad;
    }
/*dibujo de la bala :P*/
    void dibujar() {
      ellipse(x, y, 10, 10);
    }
/*VERIFICACION SI LA BALA ESTA FUERA DEL LIENZO*/
    boolean estaFuera() {
      return (x < 0 || x > width || y < 0 || y > height);
    }
  }
}
