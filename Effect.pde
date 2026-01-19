interface Effect {
  void apply(Player p);
  void remove(Player p);
  void update();
  boolean isExpired();
}


abstract class TimedEffect implements Effect {

  protected int duration;

  public TimedEffect(int duration) {
    this.duration = duration;
  }

  public void update() {
    duration--;
  }

  public boolean isExpired() {
    return duration <= 0;
  }
}


class SpeedBoostEffect extends TimedEffect {

  float amount;

  public SpeedBoostEffect(int duration, float amount) {
    super(duration);
    this.amount = amount;
  }

  public void apply(Player p) {
    p.setTopSpeed(p.getTopSpeed() + amount);
  }

  public void remove(Player p) {
    p.setTopSpeed(p.getTopSpeed() - amount);
  }
}
