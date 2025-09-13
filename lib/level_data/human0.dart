import 'package:flame/components.dart';
import 'package:starflame/planet.dart';

import 'level.dart';

final SceneLevelData human0 = SceneLevelData(
  planets: [
    (id: 0, playerIdx: 0, type: PlanetType.terran, position: Vector2(-330, 0)),
    (id: 1, playerIdx: 0, type: PlanetType.arid, position: Vector2(-30, 450)),
    (id: 2, playerIdx: 0, type: PlanetType.exo, position: Vector2(-630, 450)),
    (id: 3, playerIdx: -1, type: PlanetType.gas, position: Vector2(-750, -60)),
    (id: 4, playerIdx: -1, type: PlanetType.exo, position: Vector2(-990, 390)),
    (id: 5, playerIdx: -1, type: PlanetType.gas, position: Vector2(-360, 690)),
    (id: 6, playerIdx: -1, type: PlanetType.arid, position: Vector2(270, 60)),
    (id: 7, playerIdx: -1, type: PlanetType.exo, position: Vector2(0, -180)),
    (id: 8, playerIdx: -1, type: PlanetType.gas, position: Vector2(360, -570)),
    (id: 9, playerIdx: 1, type: PlanetType.ice, position: Vector2(840, -480)),
    (id: 10, playerIdx: 1, type: PlanetType.ice, position: Vector2(1040, -60)),
    (id: 11, playerIdx: 1, type: PlanetType.ice, position: Vector2(570, -60)),
  ],
  connectedPlanets: {
    0: [1, 2, 3, 7],
    1: [0, 2, 5, 6],
    2: [0, 1, 3, 4, 5],
    3: [0, 2, 4],
    4: [2, 3],
    5: [1, 2],
    6: [1, 7, 11],
    7: [0, 6, 8],
    8: [7, 9, 11],
    9: [8, 10, 11],
    10: [9, 11],
    11: [6, 8, 9, 10],
  },
  players: [
    (playerIdx: 0, isAI: false),
    (playerIdx: 1, isAI: true),
  ],
);
