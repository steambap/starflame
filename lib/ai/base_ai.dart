import "../scifi_game.dart";
import "../player_state.dart";
import "../planet.dart";

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
    if (!playerState.canTakeAction()) {
      return;
    }

    return;
  }
}
