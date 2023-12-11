import 'dart:async';

import 'package:flame/components.dart';
import "package:flame/effects.dart";
import 'scifi_game.dart';
import "cell.dart";

class Ship extends PositionComponent with HasGameRef<ScifiGame> {
  late SpriteComponent _fleetSprite;
  late SpriteComponent _fleetEffect;
  Cell cell;

  Ship(this.cell) : super(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    final imgShip = game.images.fromCache("ship_L.png");
    final spriteShip = Sprite(imgShip);
    _fleetSprite = SpriteComponent(
        sprite: spriteShip,
        anchor: Anchor.center,
        scale: Vector2.all(0.5),
        priority: 1);
    add(_fleetSprite);

    final imgEffect = game.images.fromCache("effect_yellow.png");
    final spriteEffect = Sprite(imgEffect);
    _fleetEffect = SpriteComponent(
        sprite: spriteEffect,
        anchor: Anchor.center,
        scale: Vector2.all(0.25),
        position: Vector2(0, 15));
    _fleetEffect.opacity = 0;
    add(_fleetEffect);

    position = cell.position;
  }

  FutureOr<void> moveAnim(Cell cell, List<Cell> fromCells) {
    final moveEffectList = fromCells.reversed.map((e) => MoveToEffect(e.position, EffectController(duration: 0.25)));
    _fleetEffect.add(OpacityEffect.fadeIn(EffectController(duration: 0.25)));
    return add(SequenceEffect([
      ...moveEffectList,
    ])
      ..onComplete = () {
        _fleetEffect
            .add(OpacityEffect.fadeOut(EffectController(duration: 0.25)));
      });
  }
}
