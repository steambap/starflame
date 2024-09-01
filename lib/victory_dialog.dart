import "package:flame/game.dart";
import "package:flame/components.dart";
import "package:flame/events.dart";

import "scifi_game.dart";
import "styles.dart" show label16, btnDefault;
import "dialog_background.dart";

class VictoryDialog extends ValueRoute<bool>
    with HasGameRef<ScifiGame>, TapCallbacks {
  static final buttonSize = Vector2(160, 32);
  VictoryDialog() : super(value: false);

  @override
  Component build() {
    return PositionComponent(
      position: game.size / 2,
      children: [
        DialogBackground(
          position: -game.size / 2,
          size: game.size,
        ),
        TextComponent(
            text: "Victory!!!",
            textRenderer: label16,
            anchor: Anchor.center,
            position: Vector2(0, -32)),
        AdvancedButtonComponent(
            defaultLabel: TextComponent(
                text: "Main Menu",
                anchor: Anchor.center,
                textRenderer: label16),
            onPressed: () => completeWith(true),
            defaultSkin:
                RectangleComponent(size: buttonSize, paint: btnDefault),
            anchor: Anchor.center,
            position: Vector2(buttonSize.x / 2 + 4, 8)),
        AdvancedButtonComponent(
            defaultLabel: TextComponent(
                text: "Continue Play",
                anchor: Anchor.center,
                textRenderer: label16),
            onPressed: () => completeWith(false),
            defaultSkin:
                RectangleComponent(size: buttonSize, paint: btnDefault),
            anchor: Anchor.center,
            position: Vector2(-4 - buttonSize.x / 2, 8)),
      ],
    );
  }
}
