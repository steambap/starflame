import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:starfury/select_control.dart';

import 'scifi_game.dart';
import 'ship_type.dart';
import 'theme.dart';

class ShipBox extends PositionComponent
    with HasGameRef<ScifiGame>, TapCallbacks {
  final Function(ShipType) onTap;
  final ShipType shipType;
  final rect = RectangleComponent(
      size: HudShipCreatePanel.shipBoxSize, paintLayers: buttonPaintLayer);
  final shipPrice =
      TextComponent(position: Vector2.all(2), textRenderer: text16);
  late final SpriteComponent shipImage;
  final shipName = TextComponent(
      anchor: Anchor.center,
      textRenderer: text16,
      position: Vector2(HudShipCreatePanel.shipBoxSize.x / 2,
          HudShipCreatePanel.shipBoxSize.y - 12));

  ShipBox(this.onTap, this.shipType, {required super.position})
      : super(size: HudShipCreatePanel.shipBoxSize);

  @override
  FutureOr<void> onLoad() {
    final img = game.images.fromCache("${shipType.name}.png");
    final sprite = Sprite(img);
    shipImage = SpriteComponent(
        sprite: sprite, anchor: Anchor.center, scale: Vector2.all(0.75));
    shipImage.position = HudShipCreatePanel.shipBoxSize / 2;

    addAll([rect, shipImage, shipName, shipPrice]);
  }

  void updateRender() {
    final playerNumber = game.controller.getHumanPlayerNumber();
    final shipCost =
        game.resourceController.getShipCost(playerNumber, shipType);
    final isUnlocked =
        game.shipDataController.isShipUnlocked(shipType, playerNumber);

    if (!isUnlocked) {
      rect.paintLayers = buttonDisabledPaintLayer;
    }

    shipName.text = shipType.name.toLowerCase();
    shipPrice.text = "\$${shipCost.toStringAsFixed(0)}";
  }

  @override
  void onTapUp(TapUpEvent event) {
    final playerNumber = game.controller.getHumanPlayerNumber();
    final shipCost =
        game.resourceController.getShipCost(playerNumber, shipType);
    final isUnlocked =
        game.shipDataController.isShipUnlocked(shipType, playerNumber);
    if (!isUnlocked ||
        shipCost > game.controller.getHumanPlayerState().energy) {
      return;
    }

    onTap(shipType);
  }
}

class HudShipCreatePanel extends PositionComponent with HasGameRef<ScifiGame> {
  static final shipBoxSize = Vector2(114, 54);
  static const shipBoxPadding = 4.0;
  final List<ShipBox> shipBoxes = [];

  HudShipCreatePanel();

  @override
  FutureOr<void> onLoad() {
    position = Vector2(
        game.size.x - (shipBoxSize.x + shipBoxPadding) * 2, shipBoxPadding);

    for (int i = 0; i < ShipType.values.length; i++) {
      final shipType = ShipType.values[i];
      final pos = Vector2(
        (i % 2 == 0) ? 0 : shipBoxSize.x + shipBoxPadding,
        (i ~/ 2) * (shipBoxSize.y + shipBoxPadding),
      );
      shipBoxes.add(ShipBox(onTap, shipType, position: pos));
    }

    addAll(shipBoxes);
  }

  void onTap(ShipType shipType) {
    game.mapGrid.selectControl = SelectControlCreateShip(shipType, game);
  }

  void updateRender() {
    for (final shipBox in shipBoxes) {
      shipBox.updateRender();
    }
  }
}
