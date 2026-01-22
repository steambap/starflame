import 'dart:async';

import 'package:flutter/material.dart' show Paint, PaintingStyle;
import 'package:flame/components.dart';

import 'scifi_game.dart';
import 'ship.dart';
import 'styles.dart';
import 'select_circle.dart';
import 'circular_progress.dart';
import 'hex.dart';

enum PlanetType { terran, arid, exo, ice, gas }

class Planet extends PositionComponent with HasGameReference<ScifiGame> {
  static const double radius = 72.0;

  final _circleSelect = SelectCircle(radius: radius + 2, anchor: Anchor.center);
  late final SpriteComponent _sprite;
  final CircularProgressBar _occupationBar = CircularProgressBar(
    radius: radius - 6,
    priority: 3,
    progressPaint: FlameTheme.occupationProgress,
  );

  final int id;
  final PlanetType type;
  final Hex hex;

  int _playerIdx = -1;
  int _homePlanet = -1;
  String name = "";

  int get playerIdx => _playerIdx;

  Planet(this.id, this.hex, this.type, {super.position})
    : super(size: Vector2.all(radius * 2));

  static double spritePosition(PlanetType type) {
    return switch (type) {
      PlanetType.gas => 0,
      PlanetType.ice => 168,
      PlanetType.exo => 168 * 2,
      PlanetType.terran => 168 * 3,
      PlanetType.arid => 168 * 4,
    };
  }

  @override
  FutureOr<void> onLoad() {
    var planetImage = game.images.fromCache("terrain.png");
    _sprite = SpriteComponent(
      sprite: Sprite(
        planetImage,
        srcPosition: Vector2(spritePosition(type), 0),
        srcSize: Vector2.all(168),
      ),
      anchor: Anchor.center,
      priority: 2,
    );
    addAll([_sprite, _occupationBar]);

    _updatePaint();

    return super.onLoad();
  }

  void _updatePaint() {
    if (isNeutral()) {
      return;
    }

    final playerState = game.g.players[_playerIdx];
    final paint = Paint()
      ..color = playerState.color.withAlpha(200)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    _circleSelect.circleColor = paint;
  }

  void setHome(int playerIdx) {
    _playerIdx = playerIdx;
    _homePlanet = playerIdx;
  }

  bool isHome() {
    return _playerIdx == _homePlanet;
  }

  Ship spawnShip() {
    final ship = Ship(_playerIdx, hex);
    game.mapGrid.add(ship);

    return ship;
  }

  void select() {
    if (_circleSelect.parent == null) {
      add(_circleSelect);
    }
  }

  void deselect() {
    _circleSelect.removeFromParent();
  }

  bool isNeutral() {
    return _playerIdx == -1;
  }
}
