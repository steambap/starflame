import "../scifi_game.dart";
import "../player_state.dart";
import "../planet.dart";
import "../building.dart";

class BaseAI {
  final ScifiGame game;

  List<Planet> myPlanets = List.empty();

  BaseAI(this.game);

  void startTurn() {
    final playerState = game.controller.currentPlayerState();
    setupInfo(playerState);
    improveEconomy(playerState);
    // add unit
    // move unit
    game.controller.endTurn();
  }

  void setupInfo(PlayerState playerState) {
    myPlanets = [];
    for (final p in game.mapGrid.planets) {
      if (p.playerNumber == playerState.playerNumber) {
        myPlanets.add(p);
      }
    }
  }

  void improveEconomy(PlayerState playerState) {
    _assignCitizen(playerState);
    if (playerState.credit > Building.bank.cost * 2) {
      _addBuilding(playerState);
    }
  }

  void _addBuilding(PlayerState playerState) {
    for (final p in myPlanets) {
      if (p.canBuild(Building.bank)) {
        final result = game.resourceController
            .addBuilding(playerState.playerNumber, p, Building.bank);
        if (result) {
          game.aiController.log(
              "Add Building [${Building.bank.displayName}] to [${p.displayName}]");
        }
        return;
      }
    }
  }

  void _assignCitizen(PlayerState playerState) {
    if (playerState.citizenIdle <= 0) {
      return;
    }

    // try to assign to home planet first
    final cell = game.mapGrid.getCapitalCell(playerState.playerNumber);
    if (cell != null) {
      final planet = cell.planet!;
      while (playerState.citizenIdle > 0 && planet.canAddCitizen()) {
        final result = game.resourceController
            .addCitizen(playerState.playerNumber, planet);
        if (result) {
          game.aiController.log("Assign Citizen to [${planet.displayName}]");
        }
      }
    }
  }
}
