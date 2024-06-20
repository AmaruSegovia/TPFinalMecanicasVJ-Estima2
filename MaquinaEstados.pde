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
}
