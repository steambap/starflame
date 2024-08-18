import "scifi_game.dart";
import "player_state.dart";
import "cell.dart";
import "ship_hull.dart";
import "resource.dart";
import "sim_props.dart";

class ResourceController {
  final ScifiGame game;

  ResourceController(this.game);

  void runProduction(int playerNumber) {
    final playerState = game.controller.getPlayerState(playerNumber);

    final income = playerIncome(playerState);
    playerState.addResource(income);
    playerState.refreshStatus();
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

  bool canColonize(int playerNumber) {
    final pState = game.controller.getPlayerState(playerNumber);

    return pState.transport > 0;
  }

  void colonize(int playerNumber, Cell cell) {
    if (!canColonize(playerNumber) || cell.sector == null) {
      return;
    }

    final playerState = game.controller.getPlayerState(playerNumber);
    playerState.transport -= 1;
    cell.sector?.colonize(playerNumber);
    if (game.controller.getHumanPlayerNumber() == playerNumber) {
      game.playerInfo.updateRender();
    }
  }

  bool canExplore(int playerNumber) {
    final pState = game.controller.getPlayerState(playerNumber);

    return pState.probe > 0;
  }

  void explore(int playerNumber, Cell cell) {
    if (!canExplore(playerNumber)) {
      return;
    }

    final playerState = game.controller.getPlayerState(playerNumber);
    playerState.probe -= 1;
    playerState.vision.add(cell.hex);

    if (game.controller.getHumanPlayerNumber() == playerNumber) {
      cell.reveal();
    }
  }
}
