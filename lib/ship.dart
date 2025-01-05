import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import "package:flame/rendering.dart";
import "package:flutter/foundation.dart" show ChangeNotifier;

import 'scifi_game.dart';
import "cell.dart";
import "hex.dart";
import "ship_state.dart";
import "ship_blueprint.dart";
import "action_type.dart";
import "action.dart";
import "select_control.dart";
import 'tile_type.dart';

class Ship extends PositionComponent
    with HasGameRef<ScifiGame>, ChangeNotifier {
  late final SpriteComponent _shipSprite;

  Hex hex;
  late ShipState state;
  ShipBlueprint blueprint;
  Map<Cell, List<Cell>> cachedPaths = const {};

  Ship(this.hex, int playerNumber, this.blueprint)
      : super(anchor: Anchor.center) {
    state = ShipState(playerNumber);
  }

  @override
  FutureOr<void> onLoad() async {
    final imgShip = game.images.fromCache(blueprint.image);

    final spriteShip = Sprite(imgShip);
    _shipSprite =
        SpriteComponent(sprite: spriteShip, anchor: Anchor.center);
    add(_shipSprite);

    position = hex.toPixel();

    final uid = game.controller.getUniqueID();
    state.id = uid;
    state.health = blueprint.maxHealth();
    resetAllActions();
  }

  void onStartMove() {}

  void onEndMove() {
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
    _shipSprite.decorator.addLast(PaintDecorator.grayscale());
    notifyListeners();
  }

  int movePoint() {
    if (state.isTurnOver) {
      return 0;
    }
    final maxMove = blueprint.movement();

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
    cachedPaths = const {};
    game.mapGrid.cellAtHex(hex)?.ship = null;
    game.mapGrid.removeShip(this);
    removeFromParent();
    if (game.mapGrid.selectControl is SelectControlShipSelected) {
      game.mapGrid.selectControl = SelectControlWaitForInput(game);
    }

    super.dispose();
  }

  void repair(int amount) {
    state.health = min(state.health + amount, blueprint.maxHealth());
    notifyListeners();
  }

  void resetAllActions() {
    final actionTypes = blueprint.actionTypes();
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
    return hex.cubeSpiral(visionRange());
  }

  int visionRange() {
    return blueprint.movement() ~/ TileType.empty.cost;
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
