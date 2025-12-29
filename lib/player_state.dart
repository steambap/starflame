import 'dart:async';
import 'dart:math';
import 'dart:ui' show Paint, PaintingStyle;

import 'package:flutter/material.dart' show Color, Colors;
import 'package:flame/components.dart';
import 'package:starflame/scifi_game.dart';

class PlayerState extends Component with HasGameReference<ScifiGame> {
  final int playerNumber;
  bool isAlive = true;
  double _resources = 0;
  final bool isAI;
  late final TimerComponent thinkTimer;
  late final TimerComponent resourceTimer;

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

  double get resources => _resources;

  set resources(double value) {
    _resources = value.clamp(0, 100);
  }

  void think() {
    if (game.paused) {
      return;
    }

    for (final planet in game.mapGrid.planets) {
      if (planet.playerIdx != playerNumber) {
        continue;
      }
    }
  }

  void _updateResources() {
    int num = 1;
    for (final planet in game.mapGrid.planets) {
      if (planet.playerIdx == playerNumber) {
        num += 1;
      }
    }

    resources += log(num);
  }

  @override
  FutureOr<void> onLoad() {
    thinkTimer = TimerComponent(
        period: 1.0, repeat: true, autoStart: false, onTick: think);
    // add(thinkTimer);
    resourceTimer = TimerComponent(
        period: 1.0, repeat: true, autoStart: true, onTick: _updateResources);
    add(resourceTimer);
    Future.delayed(const Duration(seconds: 2), () {
      thinkTimer.timer.start();
    });

    return super.onLoad();
  }
}
