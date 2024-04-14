import "dart:collection";

import "../scifi_game.dart";
import "base_ai.dart";

class AIController {
  final ScifiGame game;
  final Map<int, BaseAI> _aiTable = {};
  final List<String> _logs = [];

  AIController(this.game);

  void init() {
    _aiTable.clear();
    for (final p in game.controller.players) {
      _aiTable[p.playerNumber] = BaseAI(game);
    }
  }

  void startTurn(int playerNumber) {
    _aiTable[playerNumber]!.startTurn();
  }

  void log(String message) {
    _logs.add(message);
  }

  UnmodifiableListView<String> get logs => UnmodifiableListView(_logs);

  void onEndPhase() {
    final playerState = game.controller.currentPlayerState();
    if (playerState.isAI) {
      log("===Ai Player ${playerState.playerNumber} Turn Ends===");
    } else {
      _logs.clear();
    }
  }
}
