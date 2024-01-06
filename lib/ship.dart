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

    final uid = game.controller.getUniqueID();
    state.id = uid;
    state.health = game.shipData.table[state.type]!.health;
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
    state.attacked = true;
    state.movementUsed = game.shipData.table[state.type]!.movementPoint;
    _shipSprite.decorator.addLast(
      PaintDecorator.tint(const Color(0x7f7f7f7f)),
    );
  }

  int movePoint() {
    if (state.isTurnOver) {
      return 0;
    }
    final maxMove = game.shipData.table[state.type]!.movementPoint;

    return max(maxMove - state.movementUsed, 0);
  }

  bool canAttack() {
    if (!game.shipData.table[state.type]!.hasDefaultWeapon) {
      return false;
    }

    if (state.isTurnOver) {
      return false;
    }

    if (state.attacked) {
      return false;
    }

    return movePoint() > 0;
  }

  void preparationPhaseUpdate() {
    state.isTurnOver = false;
    state.attacked = false;
    state.movementUsed = 0;
    _shipSprite.decorator.removeLast();
  }
}
