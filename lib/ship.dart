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
  late Component _behaviour = OrbitingBehaviour();
  bool isMovingOut = false;
  double orbitTime = 0;
  double attackCD = 0;
  double attacked = 0;
  late final double orbitRadius;
  int hp = 100;

  Ship(this.playerIdx, Planet planet) : super(anchor: Anchor.center) {
    _targetPlanet = planet;
  }

  Planet get targetPlanet => _targetPlanet;

  Component get behaviour => _behaviour;
  set behaviour(Component value) {
    _behaviour.removeFromParent();
    _behaviour = value;
    add(_behaviour);
  }

  @override
  void update(double dt) {
    _calcOrbitTime(dt);
    _maybeAttack(dt);
    _maybeMoveIntoOrbit();

    attacked -= dt;
    if (attacked < 0) {
      attacked = 0;
    }

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
        other.receiveDamage(8 + game.rand.nextInt(45));
      });
    }

    super.onCollision(intersectionPoints, other);
  }

  void attackMove(Planet value) {
    _targetPlanet = value;
    isMovingOut = true;
    behaviour = AttackMoveBehaviour();
  }

  void defend(Planet value) {
    _targetPlanet = value;
    isMovingOut = false;
    behaviour = OrbitingBehaviour();
  }

  void _calcOrbitTime(double dt) {
    if (targetPlanet.attackingShips.contains(this)) {
      orbitTime -= dt;
    } else {
      orbitTime += dt; // Normal orbit speed
    }

    if (orbitTime >= 2 * pi) {
      orbitTime = 0;
    }
    if (orbitTime <= -2 * pi) {
      orbitTime = 0;
    }
  }

  Vector2 orbitPosition() {
    return Vector2(
      targetPlanet.position.x + orbitRadius * cos(orbitTime),
      targetPlanet.position.y + orbitRadius * sin(orbitTime),
    );
  }

  void _maybeMoveIntoOrbit() {
    if (!inOrbit()) {
      return;
    }

    if (!isMovingOut) {
      return;
    }

    isMovingOut = false;
    if (_targetPlanet.playerIdx == playerIdx) {
      if (_targetPlanet.isFullOfShips()) {
        removeFromParent();
      } else if (!_targetPlanet.ships.contains(this)) {
        _targetPlanet.ships.add(this);
        defend(_targetPlanet);
      }
    } else {
      _targetPlanet.attackingShips.add(this);
    }
  }

  void _maybeAttack(double dt) {
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
    attacked = 1;
    hp -= damage;
    if (hp <= 0) {
      removeFromParent();
      return true;
    }
    return false;
  }

  double shipSpeed() {
    final mod = attacked > 0 ? 0.5 : 1.0;
    return 100.0 * mod;
  }

  @override
  FutureOr<void> onLoad() {
    orbitRadius = Planet.radius + game.rand.nextDouble() * attackRange * 0.5;
    orbitTime = game.rand.nextDouble() * pi * 2;
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
      _behaviour,
    ]);

    return super.onLoad();
  }
}

class OrbitingBehaviour extends Component with ParentIsA<Ship> {
  @override
  void update(double dt) {
    final ship = parent;
    final orbitPos = ship.orbitPosition();
    final dir = orbitPos - ship.position;

    ship.lookAt(orbitPos);
    ship.position += dir.normalized() * ship.shipSpeed() * dt;
  }
}

class AttackMoveBehaviour extends Component with ParentIsA<Ship> {
  @override
  void update(double dt) {
    final ship = parent;
    final orbitPos = ship.orbitPosition();
    final dir = orbitPos - ship.position;

    ship.lookAt(ship.targetPlanet.position);
    ship.position += dir.normalized() * ship.shipSpeed() * dt;
  }
}
