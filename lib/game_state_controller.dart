import "scifi_game.dart";
import "game_state.dart";
import "player_state.dart";

class GameStateController {
  GameState gameState = GameState();
  List<PlayerState> players = List.empty();
  final ScifiGame game;

  GameStateController(this.game);

  void startGame(List<PlayerState> players) {
    this.players = players;
    gameState = GameState();

    game.playerInfo.updateRender();
  }

  void endTurn() {
    if (gameState.isGameOver != null && !gameState.isContinue) {
      return;
    }

    game.mapGrid.blockSelect();
    // TODO end phase

    gameState.playerNumber += 1;
    if (gameState.playerNumber >= players.length) {
      gameState.playerNumber = 0;
      gameState.turn += 1;
    }

    // TODO preparation phase
    if (currentPlayerState().isAlive) {
      productionPhaseUpdate();
      _startTurn();
    } else {
      endTurn();
    }
  }

  void _startTurn() {
    if (isCPUTurn()) {
      endTurn();
    } else {
      // TODO auto save
      game.playerInfo.updateRender();
      game.mapGrid.unSelect();
    }
  }

  void productionPhaseUpdate() {
    players[gameState.playerNumber].produceResource(game.resourceController);
    game.playerInfo.updateRender();
  }

  bool isCPUTurn() => currentPlayerState().isCPU;

  int getHumanPlayerNumber () {
    for (int i = 0; i < players.length; i++) {
      final player = players[i];
      if (!player.isCPU) {
        return i;
      }
    }

    return 0;
  }

  PlayerState getHumanPlayerState() {
    return players[getHumanPlayerNumber()];
  }

  PlayerState getPlayerState(int playerNumber) {
    return players[playerNumber];
  }

  PlayerState currentPlayerState() {
    return getPlayerState(gameState.playerNumber);
  }
}
