class EffectManager {

  private ArrayList<Effect> effects = new ArrayList<>();
  private EffectTarget target;

  public EffectManager(EffectTarget target) {
    this.target = target;
  }

  public void addEffect(Effect e) {
    e.apply(target);
    effects.add(e);
  }

  public void update(float delta) {
    for (int i = effects.size()-1; i >= 0; i--) {
      Effect e = effects.get(i);
      e.update(delta);

      if (e.isExpired()) {
        e.remove(target);
        effects.remove(i);
      }
    }
  }
}
