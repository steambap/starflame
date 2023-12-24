import "package:starfury/cell.dart";
import "package:starfury/ship_type.dart";

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
    game.shipCreatePanel.updateRender();
    lookAtCapital();
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
      game.shipCreatePanel.updateRender();
      game.mapGrid.unSelect();
      lookAtCapital();
    }
  }

  void productionPhaseUpdate() {
    players[gameState.playerNumber].produceResource(game.resourceController);
    game.playerInfo.updateRender();
  }

  bool isCPUTurn() => currentPlayerState().isCPU;

  int getHumanPlayerNumber() {
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

  createShip(Cell cell, ShipType shipType, int playerNumber) {
    if (cell.ship != null) {
      return;
    }

    final playerState = getPlayerState(playerNumber);
    final cost = game.resourceController.getShipCost(playerNumber, shipType);
    playerState.addEnergy(-cost);

    if (playerNumber == getHumanPlayerNumber()) {
      game.playerInfo.updateRender();
    }

    game.mapGrid.createShipAt(cell);
  }
}
