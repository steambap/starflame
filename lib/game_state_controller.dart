import "cell.dart";
import "scifi_game.dart";
import "game_state.dart";
import "player_state.dart";
import "ship.dart";
import "resource.dart";

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
    game.playerInfo.addListener();
    endTurn(true);
  }

  void lookAtCapital() {
    final cell = game.mapGrid.getCapitalCell(getHumanPlayerNumber());
    if (cell != null) {
      game.camera.moveTo(cell.position);
    }
  }

  void endTurn(bool isStartGame) {
    if (gameState.isGameOver != null && !gameState.isContinue) {
      return;
    }

    if (!isStartGame) {
      game.aiController.onEndPhase();
      game.mapGrid.blockSelect();

      gameState.playerNumber += 1;
      if (gameState.playerNumber >= players.length) {
        gameState.playerNumber = 0;
        gameState.turn += 1;
      }
    }

    if (currentPlayerState().isAlive) {
      preparationPhaseUpdate();
      productionPhaseUpdate();
      _startTurn();
    } else {
      endTurn(false);
    }
  }

  void _startTurn() {
    if (isAITurn()) {
      game.aiController.startTurn(gameState.playerNumber);
    } else {
      // TODO auto save
      game.mapGrid.unSelect();
    }
  }

  void productionPhaseUpdate() {
    game.resourceController.runProduction(gameState.playerNumber);
  }

  void preparationPhaseUpdate() {
    for (final planet in game.mapGrid.planets) {
      planet.phaseUpdate(gameState.playerNumber);
    }
    for (final ship
        in game.mapGrid.shipMap[gameState.playerNumber] ?? List<Ship>.empty()) {
      ship.preparationPhaseUpdate();
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

  createShip(Cell cell, int playerNumber) {
    if (cell.ship != null) {
      return;
    }

    final playerState = getPlayerState(playerNumber);
    // TODO ship template
    final tmpl = playerState.templates[0];
    playerState.addResource(Resources(credit: -tmpl.cost(), production: -5));

    game.mapGrid.createShipAt(cell, playerNumber, tmpl);
  }

  int getUniqueID() {
    gameState.uid += 1;
    return gameState.uid;
  }
}
