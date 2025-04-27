import "package:flame/components.dart";

import "action.dart";
import "scifi_game.dart";
import "cell.dart";
import 'ship.dart';
import 'ship_blueprint.dart';
import 'hud_state.dart';
import './widgets/hud_top_left.dart';
import './widgets/map_deploy.dart';

sealed class SelectControl {
  final ScifiGame game;

  SelectControl(this.game);

  void onCellClick(Cell cell) {}

  void onStateEnter() {}

  void onStateExit() {}
}

class SelectControlBlockInput extends SelectControl {
  SelectControlBlockInput(super.game);
}

class SelectControlWaitForInput extends SelectControl {
  SelectControlWaitForInput(super.game);

  @override
  void onCellClick(Cell cell) {
    final pState = game.controller.getHumanPlayerState();
    if (!pState.vision.contains(cell.hex)) {
      return;
    }

    if (cell.ship != null) {
      game.mapGrid.selectControl = SelectControlShipSelected(game, cell.ship!);
    } else if (cell.sector != null) {
      game.mapGrid.selectControl = SelectControlPlanet(game, cell);
    }
  }
}

/// Base class for selecting a cell or planet or ship
class SelectControlHex extends SelectControl {
  SelectControlHex(super.game);

  @override
  void onCellClick(Cell cell) {
    final pState = game.controller.getHumanPlayerState();
    if (!pState.vision.contains(cell.hex)) {
      game.mapGrid.selectControl = SelectControlWaitForInput(game);
      return;
    }

    if (cell.ship != null) {
      game.mapGrid.selectControl = SelectControlShipSelected(game, cell.ship!);
    } else if (cell.sector != null) {
      game.mapGrid.selectControl = SelectControlPlanet(game, cell);
    } else {
      game.mapGrid.selectControl = SelectControlWaitForInput(game);
    }
  }
}

class SelectControlShipSelected extends SelectControlHex {
  late final Cell cell;
  final Ship ship;
  Set<Cell> attackableCells = {};

  SelectControlShipSelected(super.game, this.ship);

  @override
  void onCellClick(Cell cell) {
    if (this.cell == cell) {
      if (cell.sector != null) {
        game.mapGrid.selectControl = SelectControlPlanet(game, cell);
      }

      return;
    }

    if (ship.cachedPaths.containsKey(cell)) {
      game.mapGrid.moveShip(ship, cell);
      game.mapGrid.selectControl = SelectControlWaitForInput(game);
    } else if (attackableCells.contains(cell)) {
      game.combatResolver.resolve(ship, cell);
      game.mapGrid.selectControl = SelectControlWaitForInput(game);
    } else {
      super.onCellClick(cell);
    }
  }

  @override
  void onStateEnter() {
    cell = game.mapGrid.cellAtHex(ship.hex)!;
    final shipOwner = ship.state.playerNumber;
    final isOwnerHuman = game.controller.getHumanPlayerNumber() == shipOwner;
    game.getIt<HudState>().ship.value = ship;
    Map<Cell, List<Cell>> paths = {};
    if (isOwnerHuman) {
      paths =
          game.mapGrid.pathfinding.findAllPath(cell, cell.ship!.movePoint());
      ship.cachedPaths = paths;
      if (ship.canAttack()) {
        final maxRange = ship.blueprint.attackRange();
        attackableCells =
            game.mapGrid.findAttackableCells(cell, Block(1, maxRange)).toSet();
      }
    }
    for (final cell in paths.keys) {
      final fromCells = paths[cell]!;
      final moveCost = fromCells.fold(0, (previousValue, element) {
        return previousValue + element.tileType.cost;
      });
      final movePoint = ship.movePoint() - moveCost;
      cell.markAsHighlight(movePoint);
    }
    for (final cell in attackableCells) {
      cell.markAsTarget();
    }

    game.overlays.removeAll([HudTopLeft.id, MapDeploy.id]);
  }

  @override
  void onStateExit() {
    game.getIt<HudState>().ship.value = null;
    for (final cell in ship.cachedPaths.keys) {
      cell.unmark();
    }
    for (final cell in attackableCells) {
      cell.unmark();
    }

    game.overlays.addAll([HudTopLeft.id]);
  }
}

class SelectControlPlanet extends SelectControlHex {
  final Cell cell;
  SelectControlPlanet(super.game, this.cell);

  @override
  void onCellClick(Cell cell) {
    if (this.cell == cell) {
      if (cell.ship != null) {
        game.mapGrid.selectControl =
            SelectControlShipSelected(game, cell.ship!);
      }

      return;
    }

    super.onCellClick(cell);
  }

  @override
  void onStateEnter() {
    game.camera.moveTo(cell.position);
    game.getIt<HudState>().sector.value = cell.sector;

    game.overlays.removeAll([HudTopLeft.id, MapDeploy.id]);
  }

  @override
  void onStateExit() {
    game.getIt<HudState>().sector.value = null;

    game.overlays.addAll([HudTopLeft.id]);
  }
}

class SelectControlCreateShip extends SelectControl {
  final Set<Cell> cells = {};
  final ShipBlueprint blueprint;
  SelectControlCreateShip(super.game, this.blueprint);

  @override
  void onCellClick(Cell cell) {
    if (cells.contains(cell)) {
      game.resourceController
          .createShip(cell, game.controller.getHumanPlayerState(), blueprint);
    }
    game.mapGrid.selectControl = SelectControlWaitForInput(game);
  }

  @override
  void onStateEnter() {
    final deployableCells = game.mapGrid
        .getShipDeployableCells(game.controller.getHumanPlayerNumber());
    for (final cell in deployableCells) {
      cells.add(cell);
      cell.markAsHighlight();
    }
  }

  @override
  void onStateExit() {
    for (final cell in cells) {
      cell.unmark();
    }
  }
}

class SelectControlWaitForAction extends SelectControl {
  final Action action;
  late final Iterable<Cell> targets;
  SelectControlWaitForAction(this.action, super.game);

  @override
  void onCellClick(Cell cell) {
    if (targets.contains(cell)) {
      action.activate(game);
    }
    game.mapGrid.selectControl = SelectControlWaitForInput(game);
  }

  @override
  void onStateEnter() {
    targets = action.getTargetCells(game);
    for (final cell in targets) {
      cell.markAsTarget();
    }
  }

  @override
  void onStateExit() {
    for (final cell in targets) {
      cell.unmark();
    }
  }
}
