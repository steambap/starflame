import "package:flame/components.dart";

import 'scifi_game.dart';
import 'cell.dart';
import './components/row_container.dart';
import 'theme.dart' show label12, icon16blue;

enum Ability {
  explore,
  expand,
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
    final playerNumber = game.controller.getHumanPlayerNumber();
    cell?.sector?.colonize(playerNumber);
  }

  @override
  Iterable<Cell> getTargetCells(ScifiGame game) {
    return game.mapGrid.cells
        .where((cell) => cell.sector?.neutral() ?? false);
  }

  @override
  bool isShow(ScifiGame game) {
    return true;
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
          text: "INF",
          textRenderer: label12,
        ),
      ],
    );
  }
}

final abilities = {
  Ability.expand: Expand(),
};
