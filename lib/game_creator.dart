import "dart:math";
import "package:flutter/material.dart" show Colors;

import "cell.dart";
import "game_settings.dart";
import 'map_creator.dart';
import "player_state.dart";

class GameCreator {
  late GameSettings gameSettings;
  late Random rand;
  late final MapCreator mapCreator;
  final List<Cell> sunList = [];
  // include sun
  final List<Cell> planetList = [];

  GameCreator() {
    mapCreator = MapCreator(this);
  }

  List<Cell> create(GameSettings gameSettings) {
    sunList.clear();
    planetList.clear();
    this.gameSettings = gameSettings;
    rand = Random(gameSettings.seed);

    final cells = mapCreator.create();
    _assignHomePlanet(cells);

    return cells;
  }

  _assignHomePlanet(List<Cell> cells) {
    final List<Cell> planets = planetList
        .where((element) => element.planet != null)
        .toList(growable: false);
    planets.shuffle(rand);

    for (final player in gameSettings.players) {
      final idx = player.playerNumber;
      planets[idx].planet!.setHomePlanet(idx);
    }
  }

  List<PlayerState> getTestPlayers(GameSettings gameSettings) {
    final humanPlayer = PlayerState(0, false)
      ..energy = gameSettings.playerStartingEnergy
      ..color = Colors.blue;
    final cpu1 = PlayerState(1, true)
      ..energy = gameSettings.playerStartingEnergy
      ..race = 1
      ..color = Colors.red;

    return [humanPlayer, cpu1];
  }
}
