import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import "package:flame/effects.dart";

import 'scifi_game.dart';
import "cell.dart";
import "theme.dart";
import "ship_state.dart";
import "ship_template.dart";

class Ship extends PositionComponent with HasGameRef<ScifiGame> {
  late SpriteComponent _shipSprite;
  late SpriteComponent _engineEffect;
  Cell cell;
  late ShipState state;
  ShipTemplate template;

  Ship(this.cell, int playerNumber, this.template)
      : super(anchor: Anchor.center) {
    state = ShipState(playerNumber);
  }

  @override
  FutureOr<void> onLoad() {
    final imgShip = game.images.fromCache(template.hull.image);
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
    state.health = template.maxHealth();
  }

  FutureOr<void> moveAnim(Cell cell, List<Cell> fromCells) {
    final moveEffectList = fromCells.reversed
        .map((e) => MoveToEffect(e.position, EffectController(duration: 0.2)));
    _engineEffect.add(OpacityEffect.fadeIn(EffectController(duration: 0.25)));
    return add(SequenceEffect([
      ...moveEffectList,
    ])
      ..onComplete = () {
        useMove(fromCells.length);
        _engineEffect
            .add(OpacityEffect.fadeOut(EffectController(duration: 0.25)));
      });
  }

  useMove(int num) {
    state.movementUsed += num;
    if (movePoint() == 0) {
      setTurnOver();
    }
  }

  void useAttack() {
    state.attacked = true;
    useMove(1);
  }

  setTurnOver() {
    state.isTurnOver = true;
    state.attacked = true;
    state.movementUsed = 999;
    _shipSprite.decorator.addLast(grayTint);
  }

  int movePoint() {
    if (state.isTurnOver) {
      return 0;
    }
    final maxMove = template.maxMove();

    return max(maxMove - state.movementUsed, 0);
  }

  bool canAttack() {
    if (state.isTurnOver) {
      return false;
    }

    if (state.attacked) {
      return false;
    }

    if (template.maxRange() == 0) {
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

  bool takeDamage(int damage) {
    state.health -= damage;
    if (state.health <= 0) {
      dispose();

      return true;
    }

    return false;
  }

  void dispose() {
    cell.ship = null;
    game.mapGrid.removeShip(this);
    removeFromParent();
  }
}
