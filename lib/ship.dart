import 'dart:async';

import 'package:flame/components.dart';
import "package:flame/effects.dart";
import 'scifi_game.dart';
import "cell.dart";

class Ship extends PositionComponent with HasGameRef<ScifiGame> {
  late SpriteComponent _shipSprite;
  late SpriteComponent _engineEffect;
  Cell cell;

  Ship(this.cell) : super(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    final imgShip = game.images.fromCache("ship_L.png");
    final spriteShip = Sprite(imgShip);
    _shipSprite = SpriteComponent(
        sprite: spriteShip,
        anchor: Anchor.center,
        scale: Vector2.all(0.5),
        priority: 1);
    add(_shipSprite);

    final imgEffect = game.images.fromCache("effect_yellow.png");
    final spriteEffect = Sprite(imgEffect);
    _engineEffect = SpriteComponent(
        sprite: spriteEffect,
        anchor: Anchor.center,
        scale: Vector2.all(0.25),
        position: Vector2(0, 15));
    _engineEffect.opacity = 0;
    add(_engineEffect);

    position = cell.position;
  }

  FutureOr<void> moveAnim(Cell cell, List<Cell> fromCells) {
    final moveEffectList = fromCells.reversed.map((e) => MoveToEffect(e.position, EffectController(duration: 0.25)));
    _engineEffect.add(OpacityEffect.fadeIn(EffectController(duration: 0.25)));
    return add(SequenceEffect([
      ...moveEffectList,
    ])
      ..onComplete = () {
        _engineEffect
            .add(OpacityEffect.fadeOut(EffectController(duration: 0.25)));
      });
  }
}
