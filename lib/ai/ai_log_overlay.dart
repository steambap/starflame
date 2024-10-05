import 'dart:ui' show PlatformDispatcher;

import "package:flame/components.dart";
import 'package:flame/game.dart';

import "../scifi_game.dart";
import "../styles.dart"
    show text12, label12, label12DarkGray, btnDefault, btnHover, secondartSize;
import "../dialog_background.dart";
import "../components/advanced_button.dart";

class AiLogOverlay extends Route with HasGameRef<ScifiGame> {
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
          onClick: game.controller.popAll,
        ),
        ScrollTextBoxComponent(
          size: textBoxSize,
          text: textList,
          textRenderer: text12,
          position: Vector2(0, -160),
          anchor: Anchor.topCenter,
          pixelRatio: PlatformDispatcher.instance.views.first.devicePixelRatio,
        ),
        AdvancedButton(
            size: secondartSize,
            defaultLabel: TextComponent(
                text: "Close", anchor: Anchor.center, textRenderer: label12),
            hoverLabel: TextComponent(
                text: "Close",
                anchor: Anchor.center,
                textRenderer: label12DarkGray),
            onReleased: game.controller.popAll,
            defaultSkin: RectangleComponent(paint: btnDefault),
            hoverSkin: RectangleComponent(paint: btnHover),
            anchor: Anchor.center,
            position: Vector2(0, 144)),
      ],
    );
  }
}
