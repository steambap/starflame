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
    if (playerState.credit > 400) {
      addBuilding(playerState);
    }

    improveFood(playerState);
    invest(playerState);
  }

  void addBuilding(PlayerState playerState) {
    for (final p in myPlanets) {
      if (p.canBuild(Building.fusionReactor)) {
        final result = game.resourceController
            .addBuilding(playerState.playerNumber, p, Building.fusionReactor);
        if (result) {
          game.aiController.log(
              "Add Building [${Building.fusionReactor.displayName}] to [${p.displayName}]");
        }
        return;
      }
    }
  }

  void improveFood(PlayerState playerState) {
    for (final p in myPlanets) {
      if (playerState.production < 10) {
        return;
      }
      if (!p.isFoodDeveloped()) {
        final result =
            game.resourceController.developFood(playerState.playerNumber, p);
        if (result) {
          game.aiController.log("Develop Food on [${p.displayName}]");
        }
      }
    }
  }

  void invest(PlayerState playerState) {
    for (final p in myPlanets) {
      if (playerState.production < 10) {
        return;
      }
      if (p.investNumber() < p.calcSupport()) {
        final result =
            game.resourceController.investTrade(playerState.playerNumber, p);
        if (result) {
          game.aiController.log("Invest Trade on [${p.displayName}]");
        }
      }
    }
  }
}
