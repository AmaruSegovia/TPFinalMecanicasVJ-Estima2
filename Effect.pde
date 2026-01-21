interface EffectTarget {
  float getTopSpeed();
  void setTopSpeed(float v);

  int getLives();
  void setLives(int v);

  float getDamage();
  void setDamage(float v);
}


interface Effect {
  void apply(EffectTarget target);
  void update(float delta);
  void remove(EffectTarget target);
  boolean isExpired();
}



abstract class TimedEffect implements Effect {

  protected float timeLeft;

  public TimedEffect(float duration) {
    this.timeLeft = duration;
  }

  public void update(float delta) {
    timeLeft -= delta;
  }

  public boolean isExpired() {
    return timeLeft <= 0;
  }
}



class SpeedBoostEffect extends TimedEffect {

  private float amount;

  public SpeedBoostEffect(float duration, float amount) {
    super(duration);
    this.amount = amount;
  }

  public void apply(EffectTarget t) {
    t.setTopSpeed(t.getTopSpeed() + amount);
  }

  public void remove(EffectTarget t) {
    t.setTopSpeed(t.getTopSpeed() - amount);
  }
}
