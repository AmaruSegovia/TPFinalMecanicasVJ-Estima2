/** Clase que representa un patron de posiciones */
class PatronEnemigo {
  private ArrayList<PVector> posiciones = new ArrayList<>();
  private ArrayList<String> tipos = new ArrayList<>();

  public void addPosicion(PVector pos, String tipo) {
    posiciones.add(pos);
    tipos.add(tipo);
  }
  
  /** Distribuye enemigos en un círculo */
  public void addCirculo(PVector centro, float radio, int cantidad, String tipo) {
    for (int i = 0; i < cantidad; i++) {
      float angulo = TWO_PI * i / cantidad;
      PVector pos = new PVector(
        centro.x + cos(angulo) * radio,
        centro.y + sin(angulo) * radio
      );
      addPosicion(pos, tipo);
    }
  }

  /** Crea una formación en cruz */
  public void addCruz(PVector centro, float offset, String tipo) {
    addPosicion(new PVector(centro.x, centro.y), tipo); // Centro
    addPosicion(new PVector(centro.x - offset, centro.y), tipo); // Izq
    addPosicion(new PVector(centro.x + offset, centro.y), tipo); // Der
    addPosicion(new PVector(centro.x, centro.y - offset), tipo); // Arriba
    addPosicion(new PVector(centro.x, centro.y + offset), tipo); // Abajo
  }

  /** Crea una fila horizontal */
  public void addFila(float y, int cantidad, String tipo) {
    for (int i = 0; i < cantidad; i++) {
      float x = (i + 1) * width / (cantidad + 1);
      addPosicion(new PVector(x, y), tipo);
    }
  }

  /** Crea una columna vertical */
  public void addColumna(float x, int cantidad, String tipo) {
    for (int i = 0; i < cantidad; i++) {
      float y = (i + 1) * height / (cantidad + 1);
      addPosicion(new PVector(x, y), tipo);
    }
  }

  /** Crea una formación en X */
  public void addX(PVector centro, float offset, String tipo) {
    addPosicion(new PVector(centro.x, centro.y), tipo); // Centro
    addPosicion(new PVector(centro.x - offset, centro.y - offset), tipo); // Arriba-Izq
    addPosicion(new PVector(centro.x + offset, centro.y - offset), tipo); // Arriba-Der
    addPosicion(new PVector(centro.x - offset, centro.y + offset), tipo); // Abajo-Izq
    addPosicion(new PVector(centro.x + offset, centro.y + offset), tipo); // Abajo-Der
  }

  public ArrayList<PVector> getPosiciones() { return posiciones; }
  public ArrayList<String> getTipos() { return tipos; }
}
