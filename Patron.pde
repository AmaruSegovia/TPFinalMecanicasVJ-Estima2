/** Clase que representa un patron de posiciones */
class PatronEnemigo {
  private ArrayList<PVector> posiciones = new ArrayList<>();
  private ArrayList<String> tipos = new ArrayList<>();

  public void addPosicion(PVector pos, String tipo) {
    posiciones.add(pos);
    tipos.add(tipo);
  }

  public ArrayList<PVector> getPosiciones() { return posiciones; }
  public ArrayList<String> getTipos() { return tipos; }
}
