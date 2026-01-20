import 'dart:async';
import 'dart:ui' show Paint, PaintingStyle;

import 'package:flame/components.dart';

import 'scifi_game.dart';
import 'cell.dart';
import 'hex.dart';

class Ship extends PositionComponent with HasGameReference<ScifiGame> {
  static const double attackRange = 24;

  final int playerIdx;
  final RectangleComponent _rectangle = RectangleComponent(
    size: Vector2.all(50),
    anchor: Anchor.center,
  );
  late SpriteComponent _iconLevel;
  late SpriteComponent _unitSize;

  Hex hex;
  Map<Cell, List<Cell>> cachedPaths = const {};

  int hp = 100;

  Ship(this.playerIdx, this.hex) : super(anchor: Anchor.center);

  @override
  void onRemove() {
    game.mapGrid.ships.remove(this);
  }

  void scrap() {
    removeFromParent();
  }

  @override
  FutureOr<void> onLoad() {
    final unitImage = game.images.fromCache("units.png");
    _iconLevel = SpriteComponent(
        sprite: Sprite(unitImage,
            srcPosition: Vector2.zero(), srcSize: Vector2.all(64)),
        anchor: Anchor.center);
    _unitSize = SpriteComponent(
        sprite: Sprite(unitImage,
            srcPosition: Vector2(960, 0), srcSize: Vector2.all(64)),
        anchor: Anchor.center);

    _rectangle.paintLayers = [
      Paint()..color = game.g.players[playerIdx].color,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    ];

    addAll([_rectangle, _iconLevel, _unitSize]);

    position = hex.toPixel();

    return super.onLoad();
  }
}
