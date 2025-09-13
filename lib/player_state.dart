import 'dart:async';
import 'dart:ui' show Paint, PaintingStyle;

import 'package:flutter/material.dart' show Color, Colors;
import 'package:flame/components.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/planet.dart';

class PlayerState extends Component with HasGameReference<ScifiGame> {
  final int playerNumber;
  bool isAlive = true;
  final bool isAI;
  late final TimerComponent thinkTimer;

  PlayerState(this.playerNumber, this.isAI, Color? color)
      : _color = color ?? Colors.grey;

  List<Paint> paintLayer = [];
  Color _color;

  Color get color => _color;

  set color(Color value) {
    _color = value;
    paintLayer = [
      Paint()..color = value.withAlpha(128),
      Paint()
        ..color = value
        ..style = PaintingStyle.stroke,
    ];
  }

  void think() {
    if (game.paused) {
      return;
    }

    for (final planet in game.mapGrid.planets) {
      if (planet.playerIdx != playerNumber) {
        continue;
      }
      if (planet.isUnderInvasion()) {
        planet.rallyPoint = null;
      } else {
        final rally =
            _pickPlanet(game.mapGrid.connectedPlanets[planet.id] ?? [], planet);
        planet.rallyPoint = rally;
      }
    }
  }

  @override
  FutureOr<void> onLoad() {
    thinkTimer = TimerComponent(
        period: 1.0, repeat: true, autoStart: false, onTick: think);
    // add(thinkTimer);
    Future.delayed(const Duration(seconds: 2), () {
      thinkTimer.timer.start();
    });

    return super.onLoad();
  }

  Planet? _pickPlanet(List<int> connected, Planet from) {
    if (connected.isEmpty) {
      return null;
    }

    Planet? rally;
    int currentPriority = 0;

    for (final idx in connected) {
      final planet = game.mapGrid.planetsMap[idx];
      if (planet == null) {
        continue;
      }

      int priority = _planetValue(planet);
      if (planet.rallyPoint == from && planet.playerIdx == playerNumber) {
        priority = -10000;
      }
      if (planet.occupationPoint > 0 && planet.playerIdx == playerNumber) {
        priority += 10;
      }
      if (planet.isNeutral()) {
        priority += 35;
      }
      if (planet.playerIdx != playerNumber) {
        priority += 25;
      }
      if (planet.occupationPoint > 0) {
        priority += 10;
      }
      if (planet.playerIdx != playerNumber && planet.rallyPoint == from) {
        priority += 10;
      }

      if (priority > currentPriority) {
        currentPriority = priority;
        rally = planet;
      }
    }

    return rally;
  }

  int _planetValue(Planet planet) {
    return switch (planet.type) {
      PlanetType.terran => 10,
      PlanetType.arid => 7,
      PlanetType.exo => 5,
      PlanetType.ice => 0,
      PlanetType.gas => 3,
    };
  }
}
