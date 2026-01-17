enum Difficulty {
  EASY(
    25,   // vidas jugador
    1.2,   // velocidad jugador
    1.9   // tamanio dungeon
  ),

  NORMAL(
    18,
    1.0,
    1.3
  ),

  HARD(
    13,
    0.8,
    1.0
  );

  final int playerLives;
  final float playerSpeed;
  final float multidungeon;

  Difficulty(int lives, float speed, float multidungeon) {
    this.playerLives = lives;
    this.playerSpeed = speed;
    this.multidungeon = multidungeon;
  }
}
