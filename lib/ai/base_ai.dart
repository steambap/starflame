import "../scifi_game.dart";
import "../player_state.dart";
import "../sector.dart";

class BaseAI {
  final ScifiGame game;

  List<Sector> mySectors = List.empty();

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
    mySectors = [];
    for (final p in game.mapGrid.sectors) {
      if (p.playerNumber == playerState.playerNumber) {
        mySectors.add(p);
      }
    }
  }

  void improveEconomy(PlayerState playerState) {
    if (!playerState.canTakeAction()) {
      return;
    }
    loop:
    for (final sector in mySectors) {
      for (final planet in sector.planets) {
        for (final slot in sector.workerSlots()) {
          if (!slot.isOccupied &&
              game.resourceController
                  .canPlaceWorker(playerState.playerNumber)) {
            game.resourceController.placeWorker(
                playerState.playerNumber, sector, planet, slot.type);
            game.aiController.log(
                "Placed ${slot.type} worker on planet ${planet.name} in sector ${sector.displayName}");

            if (!playerState.canTakeAction()) {
              break loop;
            }
          }
        }
      }
    }
  }
}
