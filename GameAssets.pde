
public class GameAssets {

  private RoomVisualRegistry roomVisuals;

  public GameAssets() {
    roomVisuals = new RoomVisualRegistry();
  }

  public void load() {
    loadRoomVisuals();
  }

  private void loadRoomVisuals() {
    roomVisuals.register(
      RoomType.NORMAL,
      new RoomVisual(loadImage("bg.png"))
    );

    roomVisuals.register(
      RoomType.BOSS,
      new RoomVisual(loadImage("bgfinalboss.png"))
    );

    /*roomVisuals.register(
      RoomType.TREASURE,
      new RoomVisual(loadImage("bgtreasure.png"))
    );*/

    roomVisuals.register(
      RoomType.SUBBOSS,
      new RoomVisual(loadImage("bgfinalboss.png"))
    );
  }

  public RoomVisualRegistry getRoomVisuals() {
    return this.roomVisuals;
  }
}
