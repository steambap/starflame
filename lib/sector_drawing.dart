import "dart:ui";
import 'package:flame/geometry.dart';
import "package:flame/components.dart";

import "planet.dart";
import "theme.dart" show green, yellow, red, blue, gray, transparentBlue;

class MiniPlanet extends PositionComponent {
  MiniPlanet({
    required this.radius,
    required this.type,
    super.position,
    super.children,
  }) {
    _paint.color = switch (type) {
      PlanetType.terran => green,
      PlanetType.desert => yellow,
      PlanetType.iron => red,
      PlanetType.ice => blue,
      _ => gray,
    };
  }

  final double radius;
  final PlanetType type;
  final Paint _paint = Paint();

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset.zero, radius, _paint);
  }
}

class Orbit extends PositionComponent {
  Orbit({
    required this.radius,
    required this.planet,
    required this.revolutionPeriod,
    double initialAngle = 0,
  })  : _paint = Paint()
          ..style = PaintingStyle.stroke
          ..color = transparentBlue,
        _angle = initialAngle {
    add(planet);
  }

  final double radius;
  final double revolutionPeriod;
  final MiniPlanet planet;
  final Paint _paint;
  double _angle;

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset.zero, radius, _paint);
  }

  @override
  void update(double dt) {
    _angle += dt / revolutionPeriod * tau;
    planet.position = Vector2(radius, 0)..rotate(_angle);
  }
}
