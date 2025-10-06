import 'dart:async';

import 'package:flutter/material.dart' show Paint, PaintingStyle;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'scifi_game.dart';
import 'ship.dart';
import 'styles.dart';
import 'rally_arrow.dart';
import 'select_circle.dart';
import 'planet_sidebar.dart';
import 'circular_progress.dart';

enum PlanetType { terran, arid, exo, ice, gas }

class Planet extends PositionComponent with HasGameReference<ScifiGame> {
  static const double radius = 72.0;

  final _circleSelect = SelectCircle(radius: radius + 2, anchor: Anchor.center);
  late final SpriteComponent _sprite;
  final CircleHitbox _hitbox =
      CircleHitbox(radius: radius, anchor: Anchor.center);
  final _planetSidebar =
      PlanetSidebar(radius + 16, anchor: Anchor.center, priority: 1);
  final CircularProgressBar _occupationBar = CircularProgressBar(
    radius: radius - 6,
    priority: 3,
    progressPaint: FlameTheme.occupationProgress,
  );
  RallyArrow _rallyArrow = RallyArrow(Vector2.zero(), Vector2.zero());

  final int id;
  final PlanetType type;
  final List<Ship> ships = [];
  final List<Ship> attackingShips = [];
  late int playerIdx;
  Planet? _rallyPoint;
  double _sendShipCD = 0;
  double _defenseCD = 0;

  double productionProgress = 0;
  int shield = 0;
  int occupationPoint = 0;

  Planet(this.id, this.playerIdx, this.type, {super.position})
      : super(size: Vector2.all(radius * 2));

  @override
  FutureOr<void> onLoad() {
    final planetImage = game.images.fromCache("${type.name}.png");
    _sprite = SpriteComponent(
        sprite: Sprite(planetImage),
        position: Vector2(0, 0),
        anchor: Anchor.center,
        priority: 2);
    addAll([_sprite, _hitbox, _occupationBar]);
    if (!isNeutral()) {
      add(_planetSidebar);
    }
    _updatePaint();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _runProduction(dt);
    _updateProdUI();
    _sendShips(dt);
    _updateDefense(dt);

    _occupationBar.progress = occupationPoint / 100;

    super.update(dt);
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return point.length <= radius + 16;
  }

  void _runProduction(double dt) {
    if (isNeutral()) {
      return;
    }
    if (isFullOfShips()) {
      return;
    }
    productionProgress += dt * productionRateOf(type);
    if (productionProgress >= 1) {
      productionProgress = 0;
      // Produce a new ship
      spawnShip();
    }
  }

  void _updateProdUI() {
    if (isNeutral()) {
      return;
    }
    _planetSidebar.shipCount = ships.length.toString();
    if (isFullOfShips()) {
      return;
    }

    _planetSidebar.productionProgress = productionProgress;
  }

  void _sendShips(double dt) {
    if (_sendShipCD > 0) {
      _sendShipCD -= dt;
      return;
    }
    if (ships.isEmpty || _rallyPoint == null) {
      return;
    }

    _sendShipCD = 1.25;
    final ship = ships.first;
    ship.attackMove(_rallyPoint ?? this);

    ships.removeAt(0);
  }

  Ship spawnShip() {
    final ship = Ship(playerIdx, this);
    ship.position = position;
    ships.add(ship);
    game.mapGrid.add(ship);

    return ship;
  }

  bool isFullOfShips() {
    return ships.length >= maxShipsCountOf(type);
  }

  void select() {
    if (_circleSelect.parent == null) {
      add(_circleSelect);
    }
  }

  void deselect() {
    _circleSelect.removeFromParent();
  }

  void capture(int playerIdx) {
    this.playerIdx = playerIdx;

    for (final ship in ships) {
      ship.removeFromParent();
    }
    ships.clear();
    for (final ship in attackingShips) {
      if (ship.playerIdx == playerIdx && !isFullOfShips()) {
        ships.add(ship);
      } else {
        ship.removeFromParent();
      }
    }
    attackingShips.clear();
    rallyPoint = null;
    productionProgress = 0;
    if (_planetSidebar.parent == null) {
      add(_planetSidebar);
    }
    _updatePaint();
  }

  void receiveDamageFrom(Ship ship, int damage) {
    // damage is before planet is captured
    if (ship.playerIdx == playerIdx) {
      return;
    }
    _defenseCD = -1;

    if (shield > 0) {
      shield -= damage;
      return;
    }

    occupationPoint += ((damage ~/ 5) - ships.length).clamp(0, 100);
    if (occupationPoint >= 100 && ship.parent != null) {
      occupationPoint = 0;
      capture(ship.playerIdx);
    }
  }

  bool isNeutral() {
    return playerIdx == -1;
  }

  bool isDefending() {
    return _rallyPoint == null;
  }

  bool isUnderInvasion() {
    return attackingShips.isNotEmpty && occupationPoint > 0;
  }

  Planet? get rallyPoint => _rallyPoint;

  set rallyPoint(Planet? p) {
    _rallyPoint = p;
    _rallyArrow.removeFromParent();
    if (p != null) {
      _rallyArrow = RallyArrow(position, p.position, priority: 1);
      add(_rallyArrow);
      _planetSidebar.isDefending = false;
    } else {
      for (final ship in ships) {
        ship.defend(this);
      }
      _planetSidebar.isDefending = true;
    }
  }

  void _updateDefense(double dt) {
    if (isNeutral()) {
      return;
    }
    if (_defenseCD <= 1) {
      _defenseCD += dt;
      return;
    }

    if (occupationPoint > 0) {
      _defenseCD = 0;
      occupationPoint = (occupationPoint - 3 - ships.length).clamp(0, 100);
    }
  }

  void _updatePaint() {
    if (isNeutral()) {
      return;
    }

    final playerState = game.mapGrid.getPlayerState(playerIdx);
    final paint = Paint()
      ..color = playerState.color.withAlpha(200)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    _circleSelect.circleColor = paint;
    _planetSidebar.setPaint(paint);
  }

  static double productionRateOf(PlanetType type) {
    return switch (type) {
      PlanetType.terran => 0.16,
      PlanetType.arid => 0.13,
      PlanetType.exo => 0.14,
      PlanetType.ice => 0.08,
      PlanetType.gas => 0.1,
    };
  }

  static int maxShipsCountOf(PlanetType type) {
    return switch (type) {
      PlanetType.terran => 7,
      PlanetType.arid => 6,
      PlanetType.exo => 6,
      PlanetType.ice => 5,
      PlanetType.gas => 5,
    };
  }
}
