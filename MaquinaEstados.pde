/** Máquina de Estados: Verificando los estados del Juego */
class EstadoJuego {

  /** Estado de inicio (Título) */
  public static final int MENU = 0;

  /** Estado in-game (Pleno Juego) */
  public static final int JUGANDO = 1;

  /** Estado de Derrota (Game Over) */
  public static final int VICTORIA = 2;

  /** Estado de Victoria (Juego Finalizado) */
  public static final int DERROTA = 3;
  
    /** Estado de Creditos (Post Juego Finalizado) */
  public static final int CREDITOS = 4;
}

/** Enum que representa las direcciones básicas */
public enum Direction {
  UP(0, -1),
  DOWN(0, 1),
  LEFT(-1, 0),
  RIGHT(1, 0);

  private final PVector vector;

  // Constructor del enum: cada dirección tiene un vector asociado
  Direction(float x, float y) {
    this.vector = new PVector(x, y);
  }

  /** Devuelve una copia del vector asociado a la direccion */
  public PVector toVector() {
    return vector.copy();
  }
}
