import "scifi_game.dart";
import "player_state.dart";
import "cell.dart";
import "ship_blueprint.dart";
import "resource.dart";
import "sim_props.dart";
import "response.dart";
import "sector.dart";
import "building.dart";

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
          energy: planet.getProp(SimProps.energy),
          production: planet.getProp(SimProps.production),
          politics: planet.getProp(SimProps.politics),
        );
      }
    }

    income += getMaintaince(state.playerNumber);

    return income;
  }

  Resources humanPlayerIncome() {
    final state = game.controller.getHumanPlayerState();

    return playerIncome(state);
  }

  Resources getMaintaince(int playerNumber) {
    Resources ret = const Resources();
    final ships = game.mapGrid.shipMap[playerNumber] ?? [];

    for (final ship in ships) {
      ret += Resources(energy: -ship.energyUpkeep());
    }

    return ret;
  }

  Response canCreateShip(PlayerState playerState, ShipBlueprint blueprint) {
    if (playerState.production < blueprint.cost) {
      return Response.error("Not enough production");
    }

    return Response.ok();
  }

  Response createShip(
      Cell cell, PlayerState playerState, ShipBlueprint blueprint) {
    if (cell.ship != null) {
      return Response.error("Cell already has a ship");
    }

    final canCreate = canCreateShip(playerState, blueprint);
    if (!canCreate.ok) {
      return canCreate;
    }

    playerState.takeAction(Resources(production: -blueprint.cost));

    game.mapGrid.createShipAt(cell, playerState.playerNumber, blueprint);

    return Response.ok();
  }

  Response canAddBuilding(PlayerState playerState, Sector sector, BuildingData building) {
    if (playerState.production < building.costOf(1)) {
      return Response.error("Not enough production to build ${building.name}");
    }

    return Response.ok();
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
}
