import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'scifi_game.dart';
import 'ship.dart';
import 'styles.dart';
import 'rally_arrow.dart';
import 'circular_progress.dart';

enum PlanetType { terran, arid, exo, ice, gas }

class Planet extends PositionComponent with HasGameReference<ScifiGame> {
  static const double productionRate = 0.29;
  static const double radius = 72.0;

  final CircleComponent _circle = CircleComponent(
      radius: radius + 2,
      paint: FlameTheme.planetHighlighter,
      anchor: Anchor.center);
  late final SpriteComponent _sprite;
  final CircleHitbox _hitbox =
      CircleHitbox(radius: radius, anchor: Anchor.center);
  final PositionComponent _productionLayer = PositionComponent(
    anchor: Anchor.center,
    position: Vector2(0, -radius - 16),
  );
  final TextComponent _shipCount = TextComponent(
    text: '',
    anchor: Anchor.center,
    textRenderer: FlameTheme.heading24,
  );
  final CircularProgressBar _productionProgressBar = CircularProgressBar(
    radius: 24,
  );
  RallyArrow _rallyArrow = RallyArrow(Vector2.zero(), Vector2.zero());

  final PlanetType type;
  final List<Ship> ships = [];
  final List<Ship> attackingShips = [];
  late int playerIdx;
  Planet? _rallyPoint;
  double _sendShipCD = 0;

  double productionProgress = 0;

  Planet(this.playerIdx, this.type, {super.position})
      : super(size: Vector2.all(radius * 2));

  @override
  FutureOr<void> onLoad() {
    final planetImage = game.images.fromCache("${type.name}.png");
    _sprite = SpriteComponent(
        sprite: Sprite(planetImage),
        position: Vector2(0, 0),
        anchor: Anchor.center,
        priority: 2);
    addAll([_sprite, _hitbox, _productionLayer]);
    _productionLayer.addAll([_shipCount, _productionProgressBar]);
    _circle.add(
      OpacityEffect.to(
        0.24,
        EffectController(
          duration: 1,
          reverseDuration: 1,
          infinite: true,
        ),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _runProduction(dt);
    _updateProdUI();
    _sendShips(dt);

    super.update(dt);
  }

  void _runProduction(double dt) {
    if (isFullOfShips()) {
      return;
    }
    productionProgress += dt * productionRate;
    if (productionProgress >= 1) {
      productionProgress = 0;
      // Produce a new ship
      spawnShip();
    }
  }

  void _updateProdUI() {
    if (_shipCount.text != ships.length.toString()) {
      _shipCount.text = ships.length.toString();
    }
    if (isFullOfShips()) {
      return;
    }

    _productionProgressBar.progress = productionProgress;
  }

  void _sendShips(double dt) {
    if (_sendShipCD > 0) {
      _sendShipCD -= dt;
      return;
    }
    if (ships.isEmpty || _rallyPoint == null) {
      return;
    }

    _sendShipCD = 0.75;
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
    return ships.length >= 5;
  }

  void select() {
    if (_circle.parent == null) {
      add(_circle);
    }
  }

  void deselect() {
    _circle.removeFromParent();
  }

  void capture(int playerIdx) {
    this.playerIdx = playerIdx;
    rallyPoint = null;
    ships.clear();
    productionProgress = 0;
  }

  Planet? get rallyPoint => _rallyPoint;

  set rallyPoint(Planet? p) {
    _rallyPoint = p;
    _rallyArrow.removeFromParent();
    if (p != null) {
      _rallyArrow = RallyArrow(position, p.position, priority: 1);
      add(_rallyArrow);
    } else {
      for (final ship in ships) {
        ship.defend(this);
      }
    }
  }
}
