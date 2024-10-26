import "scifi_game.dart";
import "player_state.dart";
import "cell.dart";
import "ship_blueprint.dart";
import "resource.dart";
import "sim_props.dart";
import "planet.dart";
import "sector.dart";
import "data/tech.dart";

class ResourceController {
  final ScifiGame game;

  ResourceController(this.game);

  void runProduction(int playerNumber) {
    final playerState = game.controller.getPlayerState(playerNumber);

    final income = playerIncome(playerState);

    playerState.onNewTurn(income);
  }

  Resources playerIncome(PlayerState state) {
    Resources income = const Resources(support: 6);

    for (final planet in game.mapGrid.sectors) {
      if (planet.playerNumber == state.playerNumber) {
        income += Resources(
          support: planet.getProp(SimProps.support).floor() - 1,
          production: planet.getProp(SimProps.production).floor(),
          credit: planet.getProp(SimProps.credit).floor(),
          science: planet.getProp(SimProps.science).floor(),
        );
      }
    }

    return income;
  }

  Resources humanPlayerIncome() {
    final state = game.controller.getHumanPlayerState();

    return playerIncome(state);
  }

  double getMaintaince(int playerNumber) {
    return 0;
  }

  bool canCreateShip(int playerNumber, ShipBlueprint blueprint) {
    final playerState = game.controller.getPlayerState(playerNumber);

    return playerState.canTakeAction() &&
        playerState.production >= blueprint.cost;
  }

  bool createShip(Cell cell, int playerNumber, ShipBlueprint blueprint) {
    if (cell.ship != null) {
      return false;
    }
    if (!canCreateShip(playerNumber, blueprint)) {
      return false;
    }

    final playerState = game.controller.getPlayerState(playerNumber);
    playerState.takeAction(Resources(production: -blueprint.cost));

    game.mapGrid.createShipAt(cell, playerNumber, blueprint);

    return true;
  }

  bool canCapture(int playerNumber) {
    return true;
  }

  void capture(int playerNumber, Cell cell) {
    if (!canCapture(playerNumber) || cell.sector == null) {
      return;
    }

    cell.sector?.colonize(playerNumber);
  }

  bool canPlaceWorker(int playerNumber) {
    final pState = game.controller.getPlayerState(playerNumber);

    return pState.canTakeAction();
  }

  void placeWorker(
      int playerNumber, Sector sector, WorkerSlot slot, WorkerType type) {
    if (!canPlaceWorker(playerNumber)) {
      return;
    }

    final playerState = game.controller.getPlayerState(playerNumber);
    playerState.takeAction(const Resources());
    sector.placeWorker(playerState, slot, type);
  }

  void switchWorker(
      int playerNumber, Sector sector, WorkerSlot slot, WorkerType type) {
    if (!canPlaceWorker(playerNumber)) {
      return;
    }

    final playerState = game.controller.getPlayerState(playerNumber);
    sector.switchWorker(playerState, slot, type);
  }

  bool canResearch(int playerNumber, String techId) {
    final playerState = game.controller.getPlayerState(playerNumber);

    if (playerState.techs.contains(techId)) {
      return false;
    }

    final tech = techMap[techId];
    if (tech == null) {
      return false;
    }

    return playerState.canTakeAction() && playerState.science >= tech.cost;
  }

  void doResearch(int playerNumber, String techId) {
    final playerState = game.controller.getPlayerState(playerNumber);

    if (!canResearch(playerNumber, techId)) {
      return;
    }

    final tech = techMap[techId]!;
    playerState.takeAction(Resources(science: -tech.cost));
    playerState.addTech(techId);
  }
}
