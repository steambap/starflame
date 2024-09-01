import 'dart:async';
import 'package:flame/components.dart';

import 'scifi_game.dart';
import 'ship.dart';
import "async_updated_ui.dart";
import 'styles.dart';
import "components/row_container.dart";
// import 'action_button.dart';

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
  // final TextComponent _shipAndTemplateName =
  //     TextComponent(textRenderer: label16, anchor: Anchor.centerLeft);
  // final TextComponent _shipInfo1 =
  //     TextComponent(textRenderer: text12, anchor: Anchor.centerLeft);
  // final TextComponent _shipInfo2 =
  //     TextComponent(textRenderer: text12, anchor: Anchor.centerLeft);
  // final TextComponentClipped _shipInfo3 = TextComponentClipped(rectSize,
  //     textRenderer: text12, anchor: Anchor.centerLeft);

  // final List<ActionButton> _shipCommandButtons = [];

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

  // void updateRender(Ship? ship) {
  //   _ship?.removeListener(_scheduleUpdateRender);
  //   if (ship != null) {
  //     ship.addListener(_scheduleUpdateRender);
  //   }
  //   _ship = ship;
  //   _scheduleUpdateRender();
  // }

  // @override
  // void _updateRender() {
  //   if (_ship != null) {
  //     _renderShip(_ship!);
  //     isVisible = true;
  //   } else {
  //     _clearActions();
  //     isVisible = false;
  //   }
  // }

  void _renderShip(Ship ship) {
    _hullName.text = ship.hull.name;
    _shipImage.sprite = Sprite(game.images.fromCache(ship.hull.image));
    _movement.text = ship.movePoint().toString();
    _row1.layout();
    // _clearActions();

    final playerIdx = game.controller.getHumanPlayerNumber();
    // if (playerIdx == ship.state.playerNumber) {
    //   final actions = ship.hull.actions();
    //   for (int i = 0; i < actions.length; i++) {
    //     final aButton = ActionButton(ship.cell, actions[i]);
    //     aButton.position = Vector2(_shipInfoBackground.x + 8,
    //         _shipInfoBackground.position.y - (i + 1) * (iconButtonSize.y + 4));
    //     _shipCommandButtons.add(
    //       aButton,
    //     );
    //   }
    //   addAll(_shipCommandButtons);
    // }
  }

  // void _clearActions() {
  //   for (final element in _shipCommandButtons) {
  //     element.removeFromParent();
  //   }
  //   _shipCommandButtons.clear();
  // }

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
