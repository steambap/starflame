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
    game.controller.endTurn(false);
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
    if (playerState.credit > Building.bank.cost * 2) {
      addBuilding(playerState);
    }
  }

  void addBuilding(PlayerState playerState) {
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
}
