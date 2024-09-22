import 'player_state.dart';

class GameSettings {
  int seed;
  int playerStartingCredit = 20;
  int mapSize = 11;
  int numOfPlanets = 20;
  List<PlayerState> players = [];

  GameSettings(this.seed);

  Map<String, dynamic> toJson() {
    return {
      'seed': seed,
      'playerStartingCredit': playerStartingCredit,
      'mapSize': mapSize,
    };
  }
}
