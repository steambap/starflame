import 'dart:async';
import 'package:flame/components.dart';

import "tile_type.dart";
import 'scifi_game.dart';

class Tile extends SpriteComponent with HasGameRef<ScifiGame> {
  final TileType tileType;
  Tile(this.tileType) : super(anchor: Anchor.center, position: Vector2.zero());

  @override
  FutureOr<void> onLoad() {
    final imgName = switch (tileType) {
      TileType.asteroidField => "asteroid.png",
      TileType.gravityRift => "gravity_rift.png",
      TileType.sun => "sun.png",
      TileType.nebula => "nebula.png",
      TileType.alphaWormHole || TileType.betaWormHole => "wormhole.png",
      _ => "asteroid.png",
    };
    final img = game.images.fromCache(imgName);
    sprite = Sprite(img);
  }
}
