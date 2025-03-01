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

  bool canBuildOrbital(PlayerState playerState, Sector sector) {
    return playerState.canTakeAction() &&
        playerState.production >= 4 &&
        sector.canBuildOrbital();
  }

  void buildOrbital(PlayerState playerState, Sector sector) {
    if (!canBuildOrbital(playerState, sector)) {
      return;
    }

    playerState.takeAction(const Resources(production: -4));
    sector.buildOrbital();
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
