import "dart:math";

import "package:starfury/planet_type_helper.dart";

import "cell.dart";
import "game_settings.dart";
import 'map_creator.dart';
import "player_state.dart";

typedef GameCreateData = (List<Cell>, List<PlayerState>);

class GameCreator {
  late GameSettings gameSettings;
  late Random rand;
  late final MapCreator mapCreator;
  final PlanetTypeHelper planetTypeHelper = PlanetTypeHelper();

  GameCreator() {
    mapCreator = MapCreator(this);
  }

  GameCreateData create(GameSettings gameSettings) {
    this.gameSettings = gameSettings;
    rand = Random(gameSettings.seed);

    final cells = mapCreator.create();
    final players = _setupPlayers(gameSettings);

    return (cells, players);
  }

  GameCreateData createTutorial() {
    return create(GameSettings(0));
  }

  List<PlayerState> _setupPlayers(GameSettings gameSettings) {
    final humanPlayer = PlayerState(0, false)
      ..energy = gameSettings.playerStartingEnergy;
    final crisis = PlayerState(1, true)
      ..energy = 999
      ..race = 1;

    return [humanPlayer, crisis];
  }
}
