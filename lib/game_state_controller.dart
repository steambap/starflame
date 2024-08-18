import "scifi_game.dart";
import "game_state.dart";
import "player_state.dart";
import "ship.dart";
import "victory_dialog.dart";

class GameStateController {
  GameState gameState = GameState();
  List<PlayerState> players = List.empty();
  final ScifiGame game;

  GameStateController(this.game);

  void initGame(List<PlayerState> players) {
    this.players = players;
    for (final element in this.players) {
      element.init();
    }
    gameState = GameState();
    game.aiController.init();
  }

  void startGame() {
    lookAtCapital();
    _prepareTurnIfAlive();
  }

  void lookAtCapital() {
    final cell = game.mapGrid.getCapitalCell(getHumanPlayerNumber());
    if (cell != null) {
      game.camera.moveTo(cell.position);
    }
  }

  void endTurn() {
    if (gameState.isGameOver != null && !gameState.isContinue) {
      return;
    }

    _onEndPhase();
    game.aiController.onEndPhase();
    game.mapGrid.blockSelect();

    gameState.playerNumber += 1;
    if (gameState.playerNumber >= players.length) {
      gameState.playerNumber = 0;
      gameState.turn += 1;
    }

    _prepareTurnIfAlive();
  }

  void _prepareTurnIfAlive() {
    if (currentPlayerState().isAlive) {
      preparationPhaseUpdate();
      productionPhaseUpdate();
      _startTurn();
    } else {
      endTurn();
    }
  }

  void _startTurn() {
    if (isAITurn()) {
      game.aiController.startTurn(gameState.playerNumber);
    } else {
      // TODO auto save
      game.mapGrid.unSelect();
      game.mapGrid.updateCellVisibility(currentPlayerState().vision);
      _checkForVictory();
    }
  }

  void productionPhaseUpdate() {
    game.resourceController.runProduction(gameState.playerNumber);
  }

  void preparationPhaseUpdate() {
    for (final planet in game.mapGrid.sectors) {
      planet.phaseUpdate(gameState.playerNumber);
    }
    for (final ship
        in game.mapGrid.shipMap[gameState.playerNumber] ?? List<Ship>.empty()) {
      ship.preparationPhaseUpdate();
    }
  }

  void _onEndPhase() {
    bool currentPlayerAlive = false;
    final int playerNumber = gameState.playerNumber;

    for (final p in game.mapGrid.sectors) {
      if (p.playerNumber == playerNumber) {
        currentPlayerAlive = true;
        break;
      }
    }

    // This player has no planet
    if (!currentPlayerAlive) {
      getPlayerState(playerNumber).isAlive = false;
    }
  }

  // Current, only human player can declare victory
  void _checkForVictory() {
    if (gameState.isGameOver != null) {
      return;
    }
    _checkConquest();
    _checkDomination();
  }
  
  void _checkConquest() {
    for (final p in players) {
      if (p.playerNumber != gameState.playerNumber && p.isAlive) {
        // someone else is still alive
        return;
      }
    }

    _winGame();
  }

  void _checkDomination() {
    final Set<int> victoryTeam = {};

    for (final p in game.mapGrid.sectors) {
      if (p.playerNumber!= null && p.homePlanet) {
        victoryTeam.add(p.playerNumber!);
      }
    }

    if (victoryTeam.length == 1) {
      if (victoryTeam.first == gameState.playerNumber) {
        _winGame();
      }
    }
  }

  void _winGame() async {
    gameState.isGameOver = true;
    final result = await game.router.pushAndWait(VictoryDialog());
    if (result) {
      // Go to main menu
    } else {
      gameState.isContinue = true;
    }
  }

  bool isAITurn() => currentPlayerState().isAI;

  int getHumanPlayerNumber() {
    for (int i = 0; i < players.length; i++) {
      final player = players[i];
      if (!player.isAI) {
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

  int getUniqueID() {
    gameState.uid += 1;
    return gameState.uid;
  }
}
