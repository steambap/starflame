import 'dart:async';
import 'dart:ui';
import 'dart:math';

import 'package:flame/components.dart';
import "package:flame/effects.dart";
import "package:flame/rendering.dart";

import 'scifi_game.dart';
import "cell.dart";
import "ship_state.dart";
import "ship_type.dart";
import "game_attribute.dart";

class Ship extends PositionComponent with HasGameRef<ScifiGame> {
  late SpriteComponent _shipSprite;
  late SpriteComponent _engineEffect;
  Cell cell;
  late ShipState state;

  Ship(this.cell, ShipType shipType, int playerNumber)
      : super(anchor: Anchor.center) {
    state = ShipState(shipType, playerNumber);
  }

  @override
  FutureOr<void> onLoad() {
    final imgShip = game.images.fromCache("${state.type.name}.png");
    final spriteShip = Sprite(imgShip);
    _shipSprite = SpriteComponent(
        sprite: spriteShip,
        anchor: Anchor.center,
        scale: Vector2.all(0.75),
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

    final uid = game.gameStateController.getUniqueID();
    state.id = uid;
  }

  FutureOr<void> moveAnim(Cell cell, List<Cell> fromCells) {
    state.movementUsed += fromCells.length;
    final moveEffectList = fromCells.reversed
        .map((e) => MoveToEffect(e.position, EffectController(duration: 0.25)));
    _engineEffect.add(OpacityEffect.fadeIn(EffectController(duration: 0.25)));
    return add(SequenceEffect([
      ...moveEffectList,
    ])
      ..onComplete = () {
        _engineEffect
            .add(OpacityEffect.fadeOut(EffectController(duration: 0.25)));
      });
  }

  setTurnOver() {
    state.isTurnOver = true;
    state.movementUsed = game.shipDataController.table[state.type]!
            .attr[GameAttribute.movementPoint] ??
        9;
    _shipSprite.decorator.addLast(
      PaintDecorator.tint(const Color(0x7f7f7f7f)),
    );
  }

  int getMovePoint() {
    if (state.isTurnOver) {
      return 0;
    }
    final maxMove = game.shipDataController.table[state.type]!
            .attr[GameAttribute.movementPoint] ??
        0;

    return max(maxMove - state.movementUsed, 0);
  }

  void preparationPhaseUpdate() {
    state.isTurnOver = false;
    state.movementUsed = 0;
    _shipSprite.decorator.removeLast();
  }
}
