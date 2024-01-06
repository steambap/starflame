import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';

import 'hex.dart';
import 'scifi_game.dart';
import 'ship.dart';
import 'theme.dart';

class HudShipCommand extends PositionComponent
    with HasGameRef<ScifiGame>, HasVisibility {
  static const double hexSize = 48;

  final PolygonComponent _hexagon = PolygonComponent(Hex.zero.polygonCorners(hexSize),
      anchor: Anchor.center, paintLayers: panelPaintLayer);
  final RectangleComponent _shipNameBox = RectangleComponent(
      size: Vector2(sqrt(3) * hexSize, 20),
      anchor: Anchor.center,
      paintLayers: panelPaintLayer);
  final TextComponent _shipName =
      TextComponent(textRenderer: text12, anchor: Anchor.center);
  final RectangleComponent _shipCommand =
      RectangleComponent(size: Vector2(200, 90), paintLayers: panelPaintLayer);
  final TextBoxComponent _shipInfo =
      TextBoxComponent(textRenderer: text12, anchor: Anchor.topLeft);
  final List<SpriteComponent> _shipCommandButtons = [];

  late final SpriteComponent _shipImage;

  @override
  FutureOr<void> onLoad() {
    // start invisible and only shows if a ship is selected
    isVisible = false;
    position = Vector2(4, game.size.y - hexSize * 2 - 24);

    _hexagon.position = Vector2(hexSize * sqrt(3) * 0.5, hexSize + 8);
    final sprite = Sprite(game.images.fromCache("colony.png"));
    _shipImage = SpriteComponent(
        sprite: sprite, anchor: Anchor.center, position: _hexagon.position);

    final shipNameCenter = Vector2(hexSize * sqrt(3) * 0.5, hexSize * 2 + 10);
    _shipNameBox.position = shipNameCenter;
    _shipName.position = shipNameCenter;

    _shipCommand.position = Vector2(hexSize * sqrt(3) + 2, 26);
    _shipInfo.position = _shipCommand.position + Vector2(0, 30);

    return addAll([
      _hexagon,
      _shipNameBox,
      _shipName,
      _shipCommand,
      _shipInfo,
      _shipImage
    ]);
  }

  void updateRender(Ship? ship, [bool isOwnerHuman = false]) {
    if (ship != null) {
      final state = ship.state;
      final type = state.type;
      final shipData = game.shipData.table[type]!;
      _shipName.text = type.name;
      _shipInfo.text =
          "HP: ${state.health} / ${shipData.health} | DPS: ${shipData.attack} | move: ${ship.movePoint()} / ${shipData.movementPoint} | range: ${shipData.minRange}-${shipData.maxRange} | vision: ${shipData.vision}";
      _shipImage.sprite = Sprite(game.images.fromCache("${type.name}.png"));
      for (final element in _shipCommandButtons) {
        element.removeFromParent();
      }
      _shipCommandButtons.clear();

      // final buttons = ship.shipType.commands.map((e) => _createButton(e)).toList();
      // _shipCommandButtons.addAll(buttons);
      // addAll(_shipCommandButtons);
      isVisible = true;
    } else {
      isVisible = false;
    }
  }
}
