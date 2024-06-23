import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';

import 'scifi_game.dart';
import "theme.dart" show text12, panelBackground, textButtonPaintLayer;
import "ai/ai_log_overlay.dart";

class HudPlayerInfo extends PositionComponent with HasGameRef<ScifiGame> {
  late final RectangleComponent _background;

  final _empireColor =
      RectangleComponent(size: Vector2(24, 24), position: Vector2(4, 4));

  late final SpriteComponent _productionIcon;
  final _productionLabel = TextComponent(
      text: "0",
      textRenderer: text12,
      position: Vector2(56, 16),
      anchor: Anchor.centerLeft);

  late final SpriteComponent _creditIcon;
  final _creditLabel = TextComponent(
      text: "0",
      textRenderer: text12,
      position: Vector2(164, 16),
      anchor: Anchor.centerLeft);

  late final SpriteComponent _scienceIcon;
  final _scienceLabel = TextComponent(
      text: "0",
      textRenderer: text12,
      position: Vector2(272, 16),
      anchor: Anchor.centerLeft);

  // late final SpriteComponent _influenceIcon;
  // final _influenceLabel = TextComponent(
  //     text: "0",
  //     textRenderer: text12,
  //     position: Vector2(380, 16),
  //     anchor: Anchor.centerLeft);
  late final AdvancedButtonComponent _aiLog;

  HudPlayerInfo();

  @override
  FutureOr<void> onLoad() {
    _background = RectangleComponent(
        size: Vector2(game.size.x, 32), paint: panelBackground);
    final creditIcon = game.images.fromCache("credit_icon.png");
    _creditIcon =
        SpriteComponent(sprite: Sprite(creditIcon), position: Vector2(144, 8));
    final prodIcon = game.images.fromCache("production_icon.png");
    _productionIcon =
        SpriteComponent(sprite: Sprite(prodIcon), position: Vector2(36, 8));
    final scienceIcon = game.images.fromCache("research_icon.png");
    _scienceIcon =
        SpriteComponent(sprite: Sprite(scienceIcon), position: Vector2(252, 8));
    // final influenceIcon = game.images.fromCache("influence_icon.png");
    // _influenceIcon = SpriteComponent(
    //     sprite: Sprite(influenceIcon), position: Vector2(360, 8));

    _aiLog = AdvancedButtonComponent(
        size: Vector2(32, 24),
        position: Vector2(game.size.x - 40, 4),
        onPressed: () => game.router.pushRoute(AiLogOverlay()),
        defaultLabel: TextComponent(
            text: "Log", textRenderer: text12, anchor: Anchor.center),
        defaultSkin: RectangleComponent(
            paintLayers: textButtonPaintLayer, size: Vector2(32, 24)));

    addAll([
      _background,
      _empireColor,
      _creditIcon,
      _creditLabel,
      _productionIcon,
      _productionLabel,
      _scienceIcon,
      _scienceLabel,
      // _influenceIcon,
      // _influenceLabel,
      _aiLog,
    ]);
  }

  void addListener() {
    game.controller.getHumanPlayerState().addListener(updateRender);
    updateRender();
  }

  void removeListener() {
    game.controller.getHumanPlayerState().removeListener(updateRender);
  }

  void updateRender() {
    final playerState = game.controller.getHumanPlayerState();
    _empireColor.paint = Paint()..color = playerState.color;
    final income = game.resourceController.humanPlayerIncome();
    _creditLabel.text =
        "${playerState.credit.toInt()}(+${income.credit.toInt()})";
    _productionLabel.text = "${playerState.production}(+${income.production})";
    _scienceLabel.text = "${playerState.science}(+${income.science})";
    // _influenceLabel.text = "${playerState.influence}(+${income.influence})";
  }
}
