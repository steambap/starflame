import "dart:math";

import "package:starfury/planet_type_helper.dart";

import "cell.dart";
import "game_settings.dart";
import 'map_creator.dart';

class GameCreator {
  late GameSettings gameSettings;
  late Random rand;
  late final MapCreator mapCreator;
  final PlanetTypeHelper planetTypeHelper = PlanetTypeHelper();

  GameCreator() {
    mapCreator = MapCreator(this);
  }

  List<Cell> create(GameSettings gameSettings) {
    this.gameSettings = gameSettings;
    rand = Random(gameSettings.seed);

    return mapCreator.create();
  }

  List<Cell> createTutorial() {
    return create(GameSettings(0));
  }
}
