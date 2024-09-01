import "package:flame/components.dart";

import "styles.dart" show heading24, panelSkin;
import "components/opacity.dart";

class NewTurnOverlay extends PositionComponent with HasOpacityProvider {
  final TextComponent _text = TextComponent(
    textRenderer: heading24,
    anchor: Anchor.center,
  );
  final _panel = RectangleComponent(
      size: Vector2(200, 64), anchor: Anchor.center, paintLayers: panelSkin);

  NewTurnOverlay(int t) {
    _text.text = "Turn $t";
    addAll([
      _panel,
      _text,
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _panel.position = Vector2(size.x / 2, size.y / 3);
    _text.position = Vector2(size.x / 2, size.y / 3);
  }
}
