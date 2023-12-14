import 'player_state.dart';

class GameSettings {
  int seed;
  int playerStartingEnergy = 100;
  int mapSize = 14;
  List<PlayerState> players = [];

  GameSettings(this.seed);
}
