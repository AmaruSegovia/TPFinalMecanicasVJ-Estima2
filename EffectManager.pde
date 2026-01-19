class EffectManager {

  ArrayList<Effect> effects = new ArrayList<Effect>();
  Player player;

  public EffectManager(Player player) {
    this.player = player;
  }

  public void addEffect(Effect e) {
    e.apply(player);
    effects.add(e);
  }

  public void update() {
    for (int i = effects.size() - 1; i >= 0; i--) {
      Effect e = effects.get(i);
      e.update();

      if (e.isExpired()) {
        e.remove(player);
        effects.remove(i);
      }
    }
  }
}
