import java.util.EnumSet;
import java.util.Map;

/** Gestor de entradas de teclado */
public class InputManager {
  // Conjunto de direcciones activas
  private EnumSet<Direction> activeDirections;
  // Estado de disparo
  private boolean shooting;
  private Direction shootDirection;

  // Mapeo de teclas a direcciones
  private final Map<Character, Direction> keyToDirection = Map.of(
    'w', Direction.UP,
    's', Direction.DOWN,
    'a', Direction.LEFT,
    'd', Direction.RIGHT
  );

  public InputManager() {
    activeDirections = EnumSet.noneOf(Direction.class);
    shooting = false;
    shootDirection = null;
  }

  /** Maneja tecla presionada */
  public void keyPressed(char key) {
    char k = Character.toLowerCase(key);

    // Movimiento
    Direction dir = keyToDirection.get(k);
    if (dir != null) activeDirections.add(dir);

    // Disparo
    switch (k) {
      case 'i': shooting = true; shootDirection = Direction.UP; break;
      case 'k': shooting = true; shootDirection = Direction.DOWN; break;
      case 'j': shooting = true; shootDirection = Direction.LEFT; break;
      case 'l': shooting = true; shootDirection = Direction.RIGHT; break;
    }
  }

  /** Maneja tecla liberada */
  public void keyReleased(char key) {
    char k = Character.toLowerCase(key);

    // Movimiento
    Direction dir = keyToDirection.get(k);
    if (dir != null) activeDirections.remove(dir);

    // Disparo
    if ("ijkl".indexOf(k) >= 0) {
      shooting = false;
      shootDirection = null;
    }
  }

  // --- Métodos de consulta ---
  /** ¿Hay alguna dirección activa? */
  public boolean isMoving() { return !activeDirections.isEmpty(); }

  /** Devuelve todas las direcciones activas (para diagonales) */
  public EnumSet<Direction> getActiveDirections() { return activeDirections.clone(); }

  /** ¿Está disparando? */
  public boolean isShooting() { return shooting; }

  /** Dirección del disparo actual */
  public Direction getShootDirection() { return shootDirection; }
}
