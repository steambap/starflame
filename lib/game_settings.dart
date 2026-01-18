typedef PlayerData = ({
  int playerIdx,
  bool isAI,
});

class GameSettings {
  int seed;
  int mapSize = 20;
  List<PlayerData> players = [
    (playerIdx: 0, isAI: false),
    (playerIdx: 1, isAI: true),
  ];

  GameSettings(this.seed);

  Map<String, dynamic> toJson() {
    return {
      'seed': seed,
      'mapSize': mapSize,
      'players': players.map((e) => {
        'playerIdx': e.playerIdx,
        'isAI': e.isAI,
      }).toList(),
    };
  }
}
