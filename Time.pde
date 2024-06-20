/** Clase estatica de uso global que representara el Deltatime */
static class Time {

  /** Metodos Asesores */
  static float getDeltaTime(float frames) {
    float deltaTime = 1.0/frames; // Calcula el deltaTime
    return deltaTime;
  }
}
