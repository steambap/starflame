import 'dart:async';
import 'package:flame/components.dart';

import 'scifi_game.dart';
import 'planet.dart';
import 'yes_no_dialog.dart';
import 'theme.dart'
    show
        text12,
        textButtonPaintLayer,
        textButtonDisabledPaintLayer,
        panelBackground;

class MenuPlanetCmd extends PositionComponent with HasGameRef<ScifiGame> {
  final Planet planet;
  final _background = RectangleComponent(
    size: Vector2(108, 88),
    paint: panelBackground,
  );
  final _colonyUpgradeButton = AdvancedButtonComponent(
    size: Vector2(100, 24),
    position: Vector2(4, 4),
    defaultLabel: TextComponent(
      text: "Colony Upgrade",
      textRenderer: text12,
    ),
    defaultSkin: RectangleComponent(
      paintLayers: textButtonPaintLayer,
    ),
    disabledSkin: RectangleComponent(
      paintLayers: textButtonDisabledPaintLayer,
    ),
  );
  final _developFoodButton = AdvancedButtonComponent(
    size: Vector2(100, 24),
    position: Vector2(4, 32),
    defaultLabel: TextComponent(
      text: "Develop Supply",
      textRenderer: text12,
    ),
    defaultSkin: RectangleComponent(
      paintLayers: textButtonPaintLayer,
    ),
    disabledSkin: RectangleComponent(
      paintLayers: textButtonDisabledPaintLayer,
    ),
  );
  final _investButton = AdvancedButtonComponent(
    size: Vector2(100, 24),
    position: Vector2(4, 60),
    defaultLabel: TextComponent(
      text: "Invest",
      textRenderer: text12,
    ),
    defaultSkin: RectangleComponent(
      paintLayers: textButtonPaintLayer,
    ),
    disabledSkin: RectangleComponent(
      paintLayers: textButtonDisabledPaintLayer,
    ),
  );

  MenuPlanetCmd(this.planet);

  @override
  FutureOr<void> onLoad() {
    final playerNumber = game.controller.getHumanPlayerNumber();
    if (planet.playerNumber != playerNumber) {
      _addMenuNonPlayer();
      return null;
    }
    _updateAllButtons();
    planet.addListener(_updateAllButtons);

    _developFoodButton.onPressed = () {
      game.resourceController.developFood(playerNumber, planet);
    };
    _investButton.onPressed = () {
      game.resourceController.investTrade(playerNumber, planet);
    };
    _colonyUpgradeButton.onPressed = () async {
      final result =
          await game.router.pushAndWait(YesNoDialog('Are you sure?'));
      if (!result) {
        return;
      }

      game.resourceController.upgradePlanet(playerNumber, planet);
    };

    addAll([
      _background,
      _colonyUpgradeButton,
      _developFoodButton,
      _investButton,
    ]);
  }

  void _addMenuNonPlayer() {}

  void _updateAllButtons() {
    final playerNumber = game.controller.getHumanPlayerNumber();
    _colonyUpgradeButton.isDisabled =
        !game.resourceController.canUpgradePlanet(playerNumber, planet);
    _developFoodButton.isDisabled =
        !game.resourceController.canDevelopFood(playerNumber, planet);
    _investButton.isDisabled =
        !game.resourceController.canInvestTrade(playerNumber, planet);
  }

  @override
  void onRemove() {
    planet.removeListener(_updateAllButtons);
    super.onRemove();
  }
}
