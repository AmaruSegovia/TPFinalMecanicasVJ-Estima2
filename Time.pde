/** Clase estatica de uso global que representara el Deltatime */
public static class Time {

  /** Metodos Asesores */
  public static float getDeltaTime(float frames) {
    float deltaTime = 1.0/frames; // Calcula el deltaTime
    return deltaTime;
  }
}
