import 'dart:async';
import 'package:flame/components.dart';

import 'scifi_game.dart';
import "styles.dart";
import "async_updated_ui.dart";
import 'research_overlay.dart';
import "components/advanced_button.dart";
import "components/row_container.dart";
import "components/rrect.dart";

class HudBottomRight extends PositionComponent
    with HasGameRef<ScifiGame>, HasVisibility, AsyncUpdatedUi {
  static final iconButtonSize = Vector2(24, 24);

  final AdvancedButton _research = AdvancedButton(
    size: iconButtonSize,
    defaultSkin: RowContainer(children: [
      TextComponent(text: "Research", textRenderer: label12),
      PositionComponent(size: iconButtonSize, children: [
        RRectangle(size: iconButtonSize, paint: iconButtonBorder),
        TextComponent(
            text: "R",
            textRenderer: label12,
            position: iconButtonSize / 2,
            anchor: Anchor.center),
      ]),
    ]),
    hoverSkin: RowContainer(children: [
      TextComponent(text: "Research", textRenderer: label12),
      PositionComponent(size: iconButtonSize, children: [
        RRectangle(size: iconButtonSize, paint: iconButtonBorderHover),
        TextComponent(
            text: "R",
            textRenderer: label12,
            position: iconButtonSize / 2,
            anchor: Anchor.center),
      ]),
    ]),
  );

  final AdvancedButton _shipDesign = AdvancedButton(
    size: iconButtonSize,
    defaultSkin: RowContainer(children: [
      TextComponent(text: "Ship Design", textRenderer: label12),
      PositionComponent(size: iconButtonSize, children: [
        RRectangle(size: iconButtonSize, paint: iconButtonBorder),
        TextComponent(
            text: "U",
            textRenderer: label12,
            position: iconButtonSize / 2,
            anchor: Anchor.center),
      ]),
    ]),
    hoverSkin: RowContainer(children: [
      TextComponent(text: "Ship Design", textRenderer: label12),
      PositionComponent(size: iconButtonSize, children: [
        RRectangle(size: iconButtonSize, paint: iconButtonBorderHover),
        TextComponent(
            text: "U",
            textRenderer: label12,
            position: iconButtonSize / 2,
            anchor: Anchor.center),
      ]),
    ]),
  );

  final AdvancedButton _build = AdvancedButton(
    size: iconButtonSize,
    defaultSkin: RowContainer(children: [
      TextComponent(text: "Build", textRenderer: label12),
      PositionComponent(size: iconButtonSize, children: [
        RRectangle(size: iconButtonSize, paint: iconButtonBorder),
        TextComponent(
            text: "B",
            textRenderer: label12,
            position: iconButtonSize / 2,
            anchor: Anchor.center),
      ]),
    ]),
    hoverSkin: RowContainer(children: [
      TextComponent(text: "Build", textRenderer: label12),
      PositionComponent(size: iconButtonSize, children: [
        RRectangle(size: iconButtonSize, paint: iconButtonBorderHover),
        TextComponent(
            text: "B",
            textRenderer: label12,
            position: iconButtonSize / 2,
            anchor: Anchor.center),
      ]),
    ]),
  );

  @override
  FutureOr<void> onLoad() {
    _build.onReleased = () {
      game.hudMapDeploy.renderShipButtons();
    };
    _research.onReleased = () {
      game.router.pushRoute(ResearchOverlay());
    };

    addAll([_build, _research, _shipDesign]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    scheduleUpdate();
  }

  @override
  void updateRender() {
    final dy = game.size.y - iconButtonSize.y - 8;

    _shipDesign.size = _shipDesign.defaultSkin?.size ?? iconButtonSize;
    _shipDesign.position = Vector2(game.size.x - 116 - _shipDesign.size.x, dy);
    _research.size = _research.defaultSkin?.size ?? iconButtonSize;
    _research.position =
        Vector2(_shipDesign.position.x - 4 - _research.size.x, dy);
    _build.size = _build.defaultSkin?.size ?? iconButtonSize;
    _build.position = Vector2(_research.position.x - 4 - _build.size.x, dy);
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    if (isVisible) {
      return super.containsLocalPoint(point);
    }

    return false;
  }
}
