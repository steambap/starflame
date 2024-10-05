import 'dart:async';
import 'package:flame/components.dart';

import 'scifi_game.dart';
import "styles.dart";
import "async_updated_ui.dart";
import 'research_overlay.dart';
import "components/advanced_button.dart";

class HudBottomRight extends PositionComponent
    with HasGameRef<ScifiGame>, HasVisibility, AsyncUpdatedUi {
  static final iconButtonSize = Vector2(24, 24);

  final AdvancedButton _research = AdvancedButton(
    size: circleIconSize,
    defaultSkin: CircleComponent(
      radius: circleIconSize.x / 2,
      paintLayers: shipBtnSkin,
    ),
    hoverSkin: CircleComponent(
      radius: circleIconSize.x / 2,
      paintLayers: shipBtnHoverSkin,
    ),
    defaultLabel: TextComponent(text: "\ue0db", textRenderer: icon16pale),
  );

  final AdvancedButton _shipDesign = AdvancedButton(
    size: circleIconSize,
    defaultSkin: CircleComponent(
      radius: circleIconSize.x / 2,
      paintLayers: shipBtnSkin,
    ),
    hoverSkin: CircleComponent(
      radius: circleIconSize.x / 2,
      paintLayers: shipBtnHoverSkin,
    ),
    defaultLabel: TextComponent(text: "\ue451", textRenderer: icon16pale),
  );

  final AdvancedButton _build = AdvancedButton(
    size: circleIconSize,
    defaultSkin: CircleComponent(
      radius: circleIconSize.x / 2,
      paintLayers: shipBtnSkin,
    ),
    hoverSkin: CircleComponent(
      radius: circleIconSize.x / 2,
      paintLayers: shipBtnHoverSkin,
    ),
    defaultLabel: TextComponent(text: "\ue1b1", textRenderer: icon16pale),
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
    final dy = game.size.y - navbarHeight - circleIconSize.y - 8;

    _shipDesign.position = Vector2(game.size.x - 124 - _shipDesign.size.x, dy);
    _research.position =
        Vector2(_shipDesign.position.x - 4 - _research.size.x, dy);
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
