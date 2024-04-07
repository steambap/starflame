import "package:flame/game.dart";
import "package:flame/components.dart";

import "scifi_game.dart";
import "theme.dart" show text16, textButtonPaintLayer, panelBackground;

class YesNoDialog extends ValueRoute<bool> with HasGameRef<ScifiGame> {
  static final buttonSize = Vector2(100, 32);
  YesNoDialog(this.text) : super(value: false);
  final String text;

  @override
  Component build() {
    return PositionComponent(
      position: game.size / 2,
      children: [
        RectangleComponent(
          position: -game.size / 2,
          size: game.size,
          paint: panelBackground,
        ),
        TextComponent(
            text: text,
            textRenderer: text16,
            anchor: Anchor.center,
            position: Vector2(0, -32)),
        AdvancedButtonComponent(
            defaultLabel: TextComponent(
                text: "Yes", anchor: Anchor.center, textRenderer: text16),
            onPressed: () => completeWith(true),
            defaultSkin: RectangleComponent(
                size: buttonSize, paintLayers: textButtonPaintLayer),
            anchor: Anchor.center,
            position: Vector2(54, 8)),
        AdvancedButtonComponent(
            defaultLabel: TextComponent(
                text: "No", anchor: Anchor.center, textRenderer: text16),
            onPressed: () => completeWith(false),
            defaultSkin: RectangleComponent(
                size: buttonSize, paintLayers: textButtonPaintLayer),
            anchor: Anchor.center,
            position: Vector2(-54, 8)),
      ],
    );
  }
}
