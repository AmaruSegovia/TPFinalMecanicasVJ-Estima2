import java.util.EnumSet;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;

/** Gestor de entradas de teclado, control del gameplay */
public class InputManager {
  /** Conjunto de direcciones activas para movimiento **/
  private EnumSet<Direction> activeDirections = EnumSet.noneOf(Direction.class);
  /** Lista de direcciones activas para disparo **/
  private final List<Direction> shootStack = new ArrayList<>();

  // Mapeo de teclas a direcciones
  private final Map<Character, Direction> keyToDirection = Map.of(
    'w', Direction.UP,
    's', Direction.DOWN,
    'a', Direction.LEFT,
    'd', Direction.RIGHT
  );

  /** Maneja tecla presionada */
  public void keyPressed(char key) {
    char k = Character.toLowerCase(key);

    // Movimiento
    Direction dir = keyToDirection.get(k);
    if (dir != null) activeDirections.add(dir);

    // Disparo: aniadir al tope si no esta
    switch (k) {
      case 'i': addShoot(Direction.UP); break;
      case 'k': addShoot(Direction.DOWN); break;
      case 'j': addShoot(Direction.LEFT); break;
      case 'l': addShoot(Direction.RIGHT); break;
    }
    // Debug opcional
    println("Pressed: " + k + " stack=" + shootStack);
  }

  /** Maneja tecla liberada */
  public void keyReleased(char key) {
    char k = Character.toLowerCase(key);

    // Movimiento
    Direction dir = keyToDirection.get(k);
    if (dir != null) activeDirections.remove(dir);

    // Disparo: quitar la tecla de la pila
    switch (k) {
      case 'i': removeShoot(Direction.UP); break;
      case 'k': removeShoot(Direction.DOWN); break;
      case 'j': removeShoot(Direction.LEFT); break;
      case 'l': removeShoot(Direction.RIGHT); break;
    }
    // Debug opcional
    println("Released: " + k + " stack=" + shootStack);
  }
  
  /** Aniadir al listado **/
  private void addShoot(Direction d) {
    if (!shootStack.contains(d)) {
      shootStack.add(d); // al final = tope
    }
  }
  /** remover del listado **/
  private void removeShoot(Direction d) {
    shootStack.remove(d); // quita si está
  }

  /** Getters **/
  /** Hay alguna direccion activa? */
  public boolean isMoving() { return !activeDirections.isEmpty(); }

  /** Devuelve todas las direcciones activas (para diagonales) */
  public EnumSet<Direction> getActiveDirections() { return activeDirections.clone(); }

  /** ¿Esta disparando? */
  public boolean isShooting() { return !shootStack.isEmpty(); }

  /** Direccio
  n del disparo actual */
  public Direction getShootDirection() {
    if (shootStack.isEmpty()) return null;
    return shootStack.get(shootStack.size() - 1); // tope de la pila
  }
}
