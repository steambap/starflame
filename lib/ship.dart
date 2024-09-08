import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import "package:flame/effects.dart";
import "package:flutter/foundation.dart" show ChangeNotifier;

import 'scifi_game.dart';
import "cell.dart";
import "hex.dart";
import "styles.dart" show grayTint;
import "ship_state.dart";
import "ship_hull.dart";
import "action_type.dart";
import "action.dart";
import "select_control.dart";
import 'tile_type.dart';

class Ship extends PositionComponent
    with HasGameRef<ScifiGame>, ChangeNotifier {
  late SpriteComponent _shipSprite;
  late SpriteComponent _engineEffect;
  Cell cell;
  late ShipState state;
  ShipHull hull;

  Ship(this.cell, int playerNumber, this.hull) : super(anchor: Anchor.center) {
    state = ShipState(playerNumber);
  }

  @override
  FutureOr<void> onLoad() {
    final imgShip = game.images.fromCache(hull.image);
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
    state.health = ShipHull.maxHealth;
    resetAllActions();
  }

  void onStartMove() {
    _engineEffect.add(OpacityEffect.fadeIn(EffectController(duration: 0.15)));
  }

  void onEndMove() {
    _engineEffect.add(OpacityEffect.fadeOut(EffectController(duration: 0.15)));
    _maybeSelectAgain();
  }

  void useMove(int num) {
    state.movementUsed += num;
    notifyListeners();
    if (movePoint() == 0) {
      setTurnOver();
    }
  }

  void _maybeSelectAgain() {
    if (state.isTurnOver || movePoint() < TileType.empty.cost) {
      return;
    }

    game.mapGrid.selectControl = SelectControlShipSelected(game, this);
  }

  void useAttack() {
    state.attacked = true;
    setTurnOver();
    notifyListeners();
  }

  void setTurnOver() {
    state.isTurnOver = true;
    if (!state.attacked && state.movementUsed == 0) {
      repair(10);
    }
    state.attacked = true;
    state.movementUsed = 999;
    _shipSprite.decorator.addLast(grayTint);
    notifyListeners();
  }

  int movePoint() {
    if (state.isTurnOver) {
      return 0;
    }
    final maxMove = hull.movement;

    return max(maxMove - state.movementUsed, 0);
  }

  bool canAttack() {
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
    updateCooldown();
  }

  bool takeDamage(int damage) {
    state.health -= damage;
    if (state.health <= 0) {
      dispose();

      return true;
    }
    notifyListeners();

    return false;
  }

  @override
  void dispose() {
    cell.ship = null;
    game.mapGrid.removeShip(this);
    removeFromParent();
    if (game.mapGrid.selectControl is SelectControlShipSelected) {
      game.mapGrid.selectControl = SelectControlWaitForInput(game);
    }

    super.dispose();
  }

  void repair(int amount) {
    state.health = min(state.health + amount, ShipHull.maxHealth);
    notifyListeners();
  }

  void resetAllActions() {
    final actionTypes = hull.actionTypes();
    state.actions.clear();
    for (final at in actionTypes) {
      state.actions.add(ActionState(at));
    }
  }

  void addCooldown(ActionType type, int cd) {
    final action = state.actions.firstWhere((element) => element.type == type,
        orElse: () => state.actions.first);
    action.cooldown += cd;
    notifyListeners();
  }

  List<Hex> vision() {
    return cell.hex.cubeSpiral(visionRange());
  }

  int visionRange() {
    return hull.movement ~/ TileType.empty.cost;
  }

  ActionState? getActionState(ActionType type) {
    for (final action in state.actions) {
      if (action.type == type) {
        return action;
      }
    }

    return null;
  }

  void updateCooldown() {
    for (final action in state.actions) {
      if (action.cooldown > 0) {
        action.cooldown--;
      }
    }
  }

  List<Action> actions() {
    return [
      Capture(this),
      Stay(this),
    ];
  }
}
