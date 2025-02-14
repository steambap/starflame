import "scifi_game.dart";
import "player_state.dart";
import "cell.dart";
import "ship_blueprint.dart";
import "resource.dart";
import "sim_props.dart";
import "planet.dart";
import "sector.dart";
import "research.dart";

class ResourceController {
  final ScifiGame game;

  ResourceController(this.game);

  void runProduction(int playerNumber) {
    final playerState = game.controller.getPlayerState(playerNumber);

    final income = playerIncome(playerState);

    playerState.onNewTurn(income);
  }

  Resources playerIncome(PlayerState state) {
    Resources income = const Resources();

    for (final planet in game.mapGrid.sectors) {
      if (planet.playerNumber == state.playerNumber) {
        income += Resources(
          support: planet.getProp(SimProps.support).floor(),
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
      int playerNumber, Sector sector, Planet planet, WorkerType type) {
    if (!canPlaceWorker(playerNumber)) {
      return;
    }

    final playerState = game.controller.getPlayerState(playerNumber);
    playerState.takeAction(const Resources());
    sector.placeWorker(playerState, planet, type);
  }

  bool canResearch(PlayerState playerState, TechSection sec, int tier) {
    if ((playerState.techLevel[sec] ?? 0) != tier - 1) {
      return false;
    }

    return playerState.canTakeAction() &&
        playerState.science >= Research.getCost(tier);
  }

  void doResearch(PlayerState playerState, TechSection sec, int tier) {
    if (!canResearch(playerState, sec, tier)) {
      return;
    }

    playerState.takeAction(Resources(science: -Research.getCost(tier)));
    playerState.addTech(sec, tier);
  }
}
