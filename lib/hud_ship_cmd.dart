import 'dart:async';
import 'package:flame/components.dart';
import 'package:starfury/select_control.dart';

import 'scifi_game.dart';
import 'ship.dart';
import "async_updated_ui.dart";
import 'styles.dart';
import "action_type.dart";
import "components/row_container.dart";
import "components/advanced_button.dart";

class HudShipCommand extends PositionComponent
    with HasGameRef<ScifiGame>, HasVisibility, AsyncUpdatedUi {
  static final panelTitleSize = Vector2(160, 24);
  static final panelBodySize = Vector2(160, 72);

  final _titleBackground =
      RectangleComponent(size: panelTitleSize, paint: panelTitleBG);
  final _infoBackground =
      RectangleComponent(size: panelBodySize, paintLayers: panelSkin);
  late final SpriteComponent _shipImage;
  final _hullName = TextComponent(
      textRenderer: label16,
      anchor: Anchor.centerLeft,
      position: Vector2(4, panelTitleSize.y / 2));

  final _row1 = RowContainer(size: Vector2.zero(), position: Vector2(4, 40));
  final _moveIcon = TextComponent(text: "\u445e", textRenderer: icon16pale);
  final _movement = TextComponent(text: "0", textRenderer: text12);

  final List<AdvancedButton> _shipActionButtons = [];

  Ship? _ship;

  @override
  FutureOr<void> onLoad() {
    // start invisible and only shows if a ship is selected
    isVisible = false;

    final sprite = Sprite(game.images.fromCache("ships/raider.png"));
    final shipImagePos = _infoBackground.position +
        Vector2(-sprite.src.width / 2, sprite.src.height / 2);
    _shipImage = SpriteComponent(
        sprite: sprite, anchor: Anchor.center, position: shipImagePos);

    _row1.addAll([
      _moveIcon,
      _movement,
    ]);

    return addAll([
      _infoBackground,
      _shipImage,
      _titleBackground,
      _hullName,
      _row1,
    ]);
  }

  @override
  void onRemove() {
    _ship?.removeListener(scheduleUpdate);
    super.onRemove();
  }

  void hide() {
    isVisible = false;
    _clearActions();
  }

  void show(Ship ship) {
    isVisible = true;
    _ship?.removeListener(scheduleUpdate);
    _ship = ship;
    _ship!.addListener(scheduleUpdate);
    updateRender();
  }

  @override
  void updateRender() {
    if (_ship != null && isVisible) {
      _renderShip(_ship!);
    }
  }

  void _renderShip(Ship ship) {
    _hullName.text = ship.hull.name;
    _shipImage.sprite = Sprite(game.images.fromCache(ship.hull.image));
    _movement.text = ship.movePoint().toString();
    _row1.layout();
    _clearActions();

    final playerIdx = game.controller.getHumanPlayerNumber();
    if (playerIdx != ship.state.playerNumber) {
      return;
    }
    final actions = ship.actions();
    for (int i = 0; i < actions.length; i++) {
      final act = actions[i];
      final aButton = AdvancedButton(
        size: circleIconSize,
        anchor: Anchor.center,
        defaultLabel: act.getLabel(game),
        defaultSkin: CircleComponent(
          radius: circleIconSize.x / 2,
          paintLayers: shipBtnSkin,
        ),
        hoverSkin: CircleComponent(
          radius: circleIconSize.x / 2,
          paintLayers: shipBtnHoverSkin,
        ),
        disabledSkin: CircleComponent(
          radius: circleIconSize.x / 2,
          paintLayers: shipBtnDisabledSkin,
        ),
        onReleased: () {
          if (act.targetType == ActionTarget.self) {
            act.activate(game);
          } else {
            game.mapGrid.selectControl = SelectControlWaitForAction(
              act,
              ship.cell,
              game,
            );
          }
        },
      );
      aButton.isDisabled = act.isDisabled(game);
      aButton.position = Vector2(
          _titleBackground.x + (8 + circleIconSize.x) * (i + 0.5),
          _titleBackground.position.y - 8 - (circleIconSize.y / 2));
      _shipActionButtons.add(
        aButton,
      );
    }
    addAll(_shipActionButtons);
  }

  void _clearActions() {
    for (final element in _shipActionButtons) {
      element.removeFromParent();
    }
    _shipActionButtons.clear();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    position =
        Vector2(size.x - 124 - panelTitleSize.x, size.y - panelBodySize.y - 8);
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    if (isVisible) {
      return super.containsLocalPoint(point);
    }

    return false;
  }
}
