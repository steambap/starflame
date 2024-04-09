import "package:flutter/foundation.dart";
import 'package:flame/components.dart';

import "scifi_game.dart";
import "add_building_button.dart";
import "planet.dart";
import "building.dart";

class HudPlanetBuilding extends PositionComponent
    with HasGameRef<ScifiGame>, HasVisibility {
  HudPlanetBuilding();

  final List<AddBuildingButton> _buildingButtons = [];

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    isVisible = false;
    position = Vector2(204, game.size.y - AddBuildingButton.buttonSize.y - 4);
    return super.onLoad();
  }

  void _clearBuildingButtons() {
    for (final element in _buildingButtons) {
      element.removeFromParent();
    }
    _buildingButtons.clear();
  }

  void updateRender(Planet? planet) {
    if (planet == null) {
      isVisible = false;
      _clearBuildingButtons();
      return;
    }

    final playerNumber = game.controller.getHumanPlayerNumber();
    if (planet.playerNumber != playerNumber) {
      return;
    }
    isVisible = true;
    _clearBuildingButtons();
    for (int i = 0; i < Building.values.length; i++) {
      final bd = Building.values[i];
      final button = AddBuildingButton(bd, (building) {
        game.resourceController.addBuilding(playerNumber, planet, building);
      });
      button.isDisabled =
          !game.resourceController.canAddBuilding(playerNumber, planet, bd);
      button.position = Vector2((AddBuildingButton.buttonSize.x + 4) * i, 0);
      _buildingButtons.add(button);
    }

    addAll(_buildingButtons);
  }
}
