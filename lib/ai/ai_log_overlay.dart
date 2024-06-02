import "package:flame/components.dart";
import 'package:flame/game.dart';

import "../scifi_game.dart";
import "../theme.dart" show text12, textButtonPaintLayer;
import "../dialog_background.dart";

class AiLogOverlay extends Route with HasGameRef<ScifiGame> {
  static final buttonSize = Vector2(100, 32);
  static final textBoxSize = Vector2(280, 280);
  AiLogOverlay({super.transparent = false}) : super(null);

  @override
  Component build() {
    final logs = game.aiController.logs;
    final textList = logs.isNotEmpty ? logs.join("\n") : "No logs yet.";
    return PositionComponent(
      position: game.size / 2,
      children: [
        DialogBackground(
          position: -game.size / 2,
          size: game.size,
        ),
        ScrollTextBoxComponent(
          size: textBoxSize,
          text: textList,
          textRenderer: text12,
          position: Vector2(0, -160),
          anchor: Anchor.topCenter,
        ),
        AdvancedButtonComponent(
            defaultLabel: TextComponent(
                text: "Close", anchor: Anchor.center, textRenderer: text12),
            onPressed: () => game.router.popRoute(this),
            defaultSkin: RectangleComponent(
                size: buttonSize, paintLayers: textButtonPaintLayer),
            anchor: Anchor.center,
            position: Vector2(0, 144)),
      ],
    );
  }
}
