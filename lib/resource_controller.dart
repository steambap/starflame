import "scifi_game.dart";
import "player_state.dart";
import "cell.dart";
import "ship_blueprint.dart";
import "resource.dart";
import "sim_props.dart";
import "planet.dart";
import "sector.dart";
import "research.dart";
import "response.dart";

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
          support: planet.getProp(SimProps.support),
          production: planet.getProp(SimProps.production),
          credit: planet.getProp(SimProps.credit),
          science: planet.getProp(SimProps.science),
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
      ret += Resources(credit: -ship.blueprint.energyUpkeep());
    }

    return ret;
  }

  Response canCreateShip(PlayerState playerState, ShipBlueprint blueprint) {
    if (!playerState.canTakeAction()) {
      return Response.error("Not enough support");
    }

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

  bool canCapture(int playerNumber) {
    return true;
  }

  void capture(int playerNumber, Cell cell) {
    if (!canCapture(playerNumber) || cell.sector == null) {
      return;
    }

    cell.sector?.colonize(playerNumber);
  }

  bool canColonizePlanet(
      PlayerState playerState, Sector sector, Planet planet) {
    return playerState.canTakeAction() &&
        sector.canColonizePlanet(planet, playerState);
  }

  void colonizePlanet(PlayerState playerState, Sector sector, Planet planet) {
    if (!canColonizePlanet(playerState, sector, planet)) {
      return;
    }

    playerState.takeAction(const Resources());
    sector.colonizePlanet(planet, playerState);
  }

  bool canIncreaseOutput(PlayerState playerState, Sector sector, String prop) {
    return playerState.canTakeAction() && sector.canIncreaseOutput(prop);
  }

  void increaseOutput(PlayerState playerState, Sector sector, String prop) {
    if (!canIncreaseOutput(playerState, sector, prop)) {
      return;
    }

    playerState.takeAction(const Resources());
    sector.increaseOutput(prop);
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

  Response canAddReputionTile(PlayerState playerState) {
    if (!playerState.canTakeAction()) {
      return Response.error("Not enough support");
    }

    return Response.ok();
  }
}
