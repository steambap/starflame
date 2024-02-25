import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';

import 'scifi_game.dart';
import "theme.dart" show text12;

class HudPlayerInfo extends PositionComponent with HasGameRef<ScifiGame> {
  late final SpriteComponent _background;

  final _empireColor =
      RectangleComponent(size: Vector2(24, 24), position: Vector2(4, 4));
  final _empireName = TextComponent(
      text: "Empire Name",
      textRenderer: text12,
      position: Vector2(36, 16),
      anchor: Anchor.centerLeft);
  late final SpriteComponent _energyIcon;
  final _energyLabel = TextComponent(
      text: "0/0",
      textRenderer: text12,
      position: Vector2(36, 44),
      anchor: Anchor.centerLeft);
  late final SpriteComponent _metalIcon;
  final _metalLabel = TextComponent(
      text: "0/0",
      textRenderer: text12,
      position: Vector2(36, 72),
      anchor: Anchor.centerLeft);

  HudPlayerInfo();

  @override
  FutureOr<void> onLoad() {
    position = Vector2(game.size.x - 172, 8);
    final bgImg = game.images.fromCache("player_info.png");
    _background = SpriteComponent(sprite: Sprite(bgImg));
    final energyIcon = game.images.fromCache("energy_icon.png");
    _energyIcon = SpriteComponent(
        sprite: Sprite(energyIcon),
        position: Vector2(4, 44),
        scale: Vector2.all(0.66),
        anchor: Anchor.centerLeft);
    final metalIcon = game.images.fromCache("metal_icon.png");
    _metalIcon = SpriteComponent(
        sprite: Sprite(metalIcon),
        position: Vector2(4, 72),
        scale: Vector2.all(0.66),
        anchor: Anchor.centerLeft);

    addAll([
      _background,
      _empireColor,
      _empireName,
      _energyIcon,
      _energyLabel,
      _metalIcon,
      _metalLabel,
    ]);
  }

  void updateRender() {
    final playerState = game.controller.getHumanPlayerState();
    final energyIncome = game.resourceController.humanPlayerEnergyIncome();
    _energyLabel.text =
        "${playerState.energy.toInt()}(${energyIncome.toInt()})";
    _empireColor.paint = Paint()..color = playerState.color;
    final metalIncome = game.resourceController.humanPlayerMetalIncome();
    _metalLabel.text = "${playerState.metal.toInt()}(${metalIncome.toInt()})";
  }
}
