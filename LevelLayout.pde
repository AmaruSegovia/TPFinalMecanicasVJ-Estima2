/** Clase para transportar la configuracion del nivel generada */
class LevelLayout {
  PVector startPos;
  PVector bossPos;
  PVector subBossPos;
  ArrayList<PVector> treasureRooms; // Lista de posiciones de tesoros

  public LevelLayout() {
    treasureRooms = new ArrayList<PVector>();
  }
}
