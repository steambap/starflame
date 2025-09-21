import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import 'scifi_game.dart';
import 'planet.dart';

class Ship extends PositionComponent
    with HasGameReference<ScifiGame>, CollisionCallbacks {
  static const double attackRange = 24;

  final int playerIdx;
  late final SpriteAnimationComponent _sprite;
  late final CircleHitbox _hitbox =
      CircleHitbox(radius: attackRange, anchor: Anchor.center);

  late Planet _targetPlanet;
  late Component _behavior = OrbitingBehavior();

  bool isMovingOut = false;
  double _orbitAngle = 0;
  double attackCD = 0;

  late final double orbitRadius;
  int hp = 100;

  Ship(this.playerIdx, Planet planet) : super(anchor: Anchor.center) {
    _targetPlanet = planet;
  }

  Planet get targetPlanet => _targetPlanet;

  Component get behaviour => _behavior;
  set behaviour(Component value) {
    _behavior.removeFromParent();
    _behavior = value;
    add(_behavior);
  }

  double get orbitAngle => _orbitAngle;
  set orbitAngle(double value) {
    _orbitAngle = value;
    if (_orbitAngle >= 2 * pi) {
      _orbitAngle = 0;
    }
    if (_orbitAngle <= -2 * pi) {
      _orbitAngle = 0;
    }
  }

  @override
  void update(double dt) {
    _updateAttackCD(dt);
    _maybeMoveIntoOrbit();

    super.update(dt);
  }

  @override
  void onRemove() {
    game.mapGrid.ships.remove(this);
    if (targetPlanet.ships.contains(this)) {
      targetPlanet.ships.remove(this);
    }
    if (targetPlanet.attackingShips.contains(this)) {
      targetPlanet.attackingShips.remove(this);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (attackCD > 0) {
      return;
    }
    if (other is Ship && other.playerIdx != playerIdx) {
      attackCD = 0.75; // Attack cooldown

      game.world.renderBullet(this, other, () {
        other.receiveDamage(88 + game.rand.nextInt(45));
      });
    }
    if (other is Planet && other.playerIdx != playerIdx) {
      attackCD = 0.75; // Attack cooldown

      game.world.renderBullet(this, other, () {
        other.receiveDamageFrom(this, 8 + game.rand.nextInt(45));
      });
    }

    super.onCollision(intersectionPoints, other);
  }

  void attackMove(Planet value) {
    _targetPlanet = value;
    isMovingOut = true;
    behaviour = MoveBehavior();
  }

  void defend(Planet value) {
    _targetPlanet = value;
    isMovingOut = false;
    behaviour = OrbitingBehavior();
  }

  void attackPlanet() {
    isMovingOut = false;
    behaviour = AttackBehavior();
  }

  Vector2 orbitPosition() {
    return Vector2(
      targetPlanet.position.x + orbitRadius * cos(_orbitAngle),
      targetPlanet.position.y + orbitRadius * sin(_orbitAngle),
    );
  }

  void scrap() {
    game.mapGrid.getPlayerState(playerIdx).resources += 1;
    removeFromParent();
  }

  void _maybeMoveIntoOrbit() {
    if (!inOrbit()) {
      return;
    }

    if (!isMovingOut) {
      return;
    }

    if (_targetPlanet.playerIdx == playerIdx) {
      if (_targetPlanet.isFullOfShips()) {
        scrap();
      } else if (!_targetPlanet.ships.contains(this)) {
        _targetPlanet.ships.add(this);
        defend(_targetPlanet);
      }
    } else {
      attackPlanet();
      _targetPlanet.attackingShips.add(this);
    }
  }

  void _updateAttackCD(double dt) {
    if (attackCD > 0) {
      attackCD -= dt;
      return;
    }
  }

  bool inOrbit() {
    return (position - targetPlanet.position).length <=
        Planet.radius + attackRange;
  }

  bool receiveDamage(int damage) {
    hp -= damage;
    if (hp <= 0) {
      removeFromParent();
      return true;
    }
    return false;
  }

  double shipSpeed() {
    return 100.0;
  }

  @override
  FutureOr<void> onLoad() {
    orbitRadius = Planet.radius + attackRange * 0.25;
    orbitAngle = game.rand.nextDouble() * pi * 2;
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
      _hitbox,
      _behavior,
    ]);

    return super.onLoad();
  }
}

class OrbitingBehavior extends Component with ParentIsA<Ship> {
  double _speed = 1.0;
  @override
  void update(double dt) {
    final ship = parent;
    ship.orbitAngle += dt * _speed;
    final orbitPos = ship.orbitPosition();
    final dir = orbitPos - ship.position;

    ship.lookAt(orbitPos);
    ship.position += dir.normalized() * ship.shipSpeed() * _speed * dt;

    _updateOrbitalSpeed();
  }

  void _updateOrbitalSpeed() {
    final ship = parent;
    final planet = ship.targetPlanet;

    if (planet.attackingShips.isEmpty) {
      _speed = 1.0;
      return;
    }

    for (final aggressor in planet.attackingShips) {
      if (ship.collidingWith(aggressor)) {
        _speed = 0.25;
        return;
      }
    }
  }
}

double _fixAngle(double angle) {
  double ret = angle - pi * 0.5;
  if (ret <= 2 * pi) {
    ret = ret + 2 * pi;
  }

  return ret;
}

class MoveBehavior extends Component with ParentIsA<Ship> {
  @override
  void onMount() {
    final ship = parent;
    ship.lookAt(ship.targetPlanet.position);

    super.onMount();
  }

  @override
  void onRemove() {
    final ship = parent;
    ship.orbitAngle = _fixAngle(ship.targetPlanet.angleTo(ship.position));

    super.onRemove();
  }

  @override
  void update(double dt) {
    final ship = parent;
    final dir = ship.targetPlanet.position - ship.position;

    ship.position += dir.normalized() * ship.shipSpeed() * dt;
  }
}

class AttackBehavior extends Component with ParentIsA<Ship> {
  static const double speed = 0.5;
  @override
  void update(double dt) {
    final ship = parent;
    ship.orbitAngle -= dt * speed;
    final orbitPos = ship.orbitPosition();
    final dir = orbitPos - ship.position;

    ship.lookAt(ship.targetPlanet.position);
    ship.position += dir.normalized() * ship.shipSpeed() * speed * dt;
  }
}
