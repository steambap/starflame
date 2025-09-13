import 'package:flutter/material.dart' show Colors;
import 'package:flame/components.dart';
import 'package:starflame/planet.dart';

import 'human0.dart';

typedef PlanetData = ({
  int id,
  int playerIdx,
  PlanetType type,
  Vector2 position
});

typedef PlayerData = ({
  int playerIdx,
  bool isAI,
});

class SceneLevelData {
  static const playerColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.brown,
    Colors.cyan,
  ];
  final List<PlanetData> planets;
  final Map<int, List<int>> connectedPlanets;
  final List<PlayerData> players;

  SceneLevelData({
    required this.planets,
    required this.connectedPlanets,
    required this.players,
  });
}

final Map<String, SceneLevelData> levelDataTable = {
  'human0': human0,
};
