import "scifi_game.dart";
import "player_state.dart";
import "cell.dart";
import "ship_hull.dart";
import "resource.dart";
import "sim_props.dart";
import "planet.dart";
import "sector.dart";

class ResourceController {
  final ScifiGame game;

  ResourceController(this.game);

  void runProduction(int playerNumber) {
    final playerState = game.controller.getPlayerState(playerNumber);

    final income = playerIncome(playerState) +
        Resources(transport: playerState.maxTransport);

    playerState.addResource(income);
  }

  Resources playerIncome(PlayerState state) {
    Resources income = const Resources();

    for (final planet in game.mapGrid.sectors) {
      if (planet.playerNumber == state.playerNumber) {
        income += Resources(
          maintaince: planet.getProp(SimProps.maintainceCost).floor(),
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

  bool canCreateShip(int playerNumber, ShipHull hull) {
    final playerState = game.controller.getPlayerState(playerNumber);

    return playerState.production >= hull.cost;
  }

  bool createShip(Cell cell, int playerNumber, ShipHull hull) {
    if (cell.ship != null) {
      return false;
    }
    if (!canCreateShip(playerNumber, hull)) {
      return false;
    }

    final playerState = game.controller.getPlayerState(playerNumber);
    playerState.addResource(Resources(production: -hull.cost));

    game.mapGrid.createShipAt(cell, playerNumber, hull);

    return true;
  }

  bool canCapture(int playerNumber) {
    final pState = game.controller.getPlayerState(playerNumber);

    return pState.transport > 0;
  }

  void capture(int playerNumber, Cell cell) {
    if (!canCapture(playerNumber) || cell.sector == null) {
      return;
    }

    final playerState = game.controller.getPlayerState(playerNumber);
    playerState.addResource(const Resources(transport: -1));
    cell.sector?.colonize(playerNumber);
  }

  bool canPlaceWorker(int playerNumber) {
    final pState = game.controller.getPlayerState(playerNumber);

    return pState.transport > 0;
  }

  void placeWorker(
      int playerNumber, Sector sector, WorkerSlot slot, WorkerType type) {
    if (!canPlaceWorker(playerNumber)) {
      return;
    }

    final playerState = game.controller.getPlayerState(playerNumber);
    playerState.addResource(const Resources(transport: -1));
    sector.placeWorker(playerState, slot, type);
  }

  void switchWorker(
      int playerNumber, Sector sector, WorkerSlot slot, WorkerType type) {
    final playerState = game.controller.getPlayerState(playerNumber);
    sector.switchWorker(playerState, slot, type);
  }
}
