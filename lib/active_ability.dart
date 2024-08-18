import "package:flame/components.dart";

import 'scifi_game.dart';
import 'cell.dart';
import './components/row_container.dart';
import 'theme.dart' show label12, icon16blue;

enum Ability {
  explore,
  expand,
  reclaim,
}

abstract class ActiveAbility {
  void activate(ScifiGame game, Cell? cell);
  bool isShow(ScifiGame game);
  Iterable<Cell> getTargetCells(ScifiGame game);
  PositionComponent getLabel(ScifiGame game);
}

class Expand extends ActiveAbility {
  @override
  void activate(ScifiGame game, Cell? cell) {
    if (cell != null) {
      game.resourceController
          .colonize(game.controller.getHumanPlayerNumber(), cell);
    }
  }

  @override
  Iterable<Cell> getTargetCells(ScifiGame game) {
    final pState = game.controller.getHumanPlayerState();
    final vision = pState.vision;
    return game.mapGrid.cells.where((cell) {
      if (!vision.contains(cell.hex)) {
        return false;
      }
      return cell.sector?.neutral() ?? false;
    });
  }

  @override
  bool isShow(ScifiGame game) {
    return game.resourceController
        .canColonize(game.controller.getHumanPlayerNumber());
  }

  @override
  PositionComponent getLabel(ScifiGame game) {
    return RowContainer(
      anchor: Anchor.center,
      children: [
        TextComponent(
          text: "\u43f4",
          textRenderer: icon16blue,
        ),
        TextComponent(
          text: "Colonize",
          textRenderer: label12,
        ),
      ],
    );
  }
}

class Explore extends ActiveAbility {
  @override
  void activate(ScifiGame game, Cell? cell) {
    if (cell != null) {
      game.resourceController
          .explore(game.controller.getHumanPlayerNumber(), cell);
    }
  }

  @override
  Iterable<Cell> getTargetCells(ScifiGame game) {
    final pState = game.controller.getHumanPlayerState();
    final vision = pState.vision;
    final Set<Cell> result = {};

    loopMap:
    for (final cell in game.mapGrid.cells) {
      if (vision.contains(cell.hex)) {
        continue loopMap;
      }
      // cell is not visible, check if it is in range
      final ns = cell.hex.getNeighbours();
      for (final n in ns) {
        final nCell = game.mapGrid.cellAtHex(n);
        if (nCell != null) {
          if (vision.contains(nCell.hex)) {
            result.add(cell);
            continue loopMap;
          }
        }
      }
    }

    return result;
  }

  @override
  bool isShow(ScifiGame game) {
    return game.resourceController
        .canExplore(game.controller.getHumanPlayerNumber());
  }

  @override
  PositionComponent getLabel(ScifiGame game) {
    return RowContainer(
      anchor: Anchor.center,
      children: [
        TextComponent(
          text: "\u4696",
          textRenderer: icon16blue,
        ),
        TextComponent(
          text: "Explore",
          textRenderer: label12,
        ),
      ],
    );
  }
}

final abilities = {
  Ability.explore: Explore(),
  Ability.expand: Expand(),
};
