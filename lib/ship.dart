import 'dart:async';

import 'package:flame/components.dart';

import 'scifi_game.dart';
import 'cell.dart';
import 'hex.dart';

class Ship extends PositionComponent with HasGameReference<ScifiGame> {
  static const double attackRange = 24;

  final int playerIdx;
  late final SpriteAnimationComponent _sprite;

  Hex hex;
  Map<Cell, List<Cell>> cachedPaths = const {};

  int hp = 100;

  Ship(this.playerIdx, this.hex) : super(anchor: Anchor.center);

  @override
  void onRemove() {
    game.mapGrid.ships.remove(this);
  }

  void scrap() {
    // game.mapGrid.getPlayerState(playerIdx).resources += 1;
    removeFromParent();
  }

  @override
  FutureOr<void> onLoad() {
    final shipImage = game.images.fromCache("ships/corvette.png");
    _sprite = SpriteAnimationComponent.fromFrameData(
        shipImage,
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.25,
          textureSize: Vector2.all(144),
          loop: true,
        ),
        anchor: Anchor.center,
        priority: 5,
        scale: Vector2.all(0.5));

    addAll([
      _sprite,
    ]);

    position = hex.toPixel();

    return super.onLoad();
  }
}
