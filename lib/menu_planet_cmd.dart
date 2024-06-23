import 'dart:async';
import 'package:flame/components.dart';

import 'scifi_game.dart';
import 'hex.dart';
import 'planet.dart';
import 'yes_no_dialog.dart';
import 'theme.dart'
    show
        text12,
        cardSkin,
        textButtonDisabledPaintLayer,
        iconButtonSize,
        grayTint;

class MenuPlanetCmd extends PositionComponent with HasGameRef<ScifiGame> {
  static final iconPos = Vector2(10, 3);

  final Planet planet;
  late final SpriteComponent _background;
  // late final AdvancedButtonComponent _addCitizen;
  // late final AdvancedButtonComponent _removeCitizen;
  late final AdvancedButtonComponent _buildingRemoveButton;
  // late final AdvancedButtonComponent _colonyUpgradeButton;
  late final AdvancedButtonComponent _repairButton;

  MenuPlanetCmd(this.planet);

  @override
  FutureOr<void> onLoad() {
    final playerNumber = game.controller.getHumanPlayerNumber();
    if (planet.playerNumber != playerNumber) {
      _addMenuNonPlayer();
      return null;
    }

    final bgImg = game.images.fromCache('planet_menu.png');
    _background = SpriteComponent(sprite: Sprite(bgImg), anchor: Anchor.center);

    // final addImg = game.images.fromCache('planet_citizen_add.png');
    // final addIcon = SpriteComponent(sprite: Sprite(addImg), position: iconPos);
    // final addIconDisabled =
    //     SpriteComponent(sprite: Sprite(addImg), position: iconPos);
    // addIconDisabled.decorator.addLast(grayTint);
    // _addCitizen = AdvancedButtonComponent(
    //   size: iconButtonSize,
    //   position: Hex.directions[2].toPixel(),
    //   defaultSkin: RectangleComponent(
    //     paintLayers: cardSkin,
    //     children: [addIcon],
    //   ),
    //   disabledSkin: RectangleComponent(
    //     paintLayers: textButtonDisabledPaintLayer,
    //     children: [addIconDisabled],
    //   ),
    //   onPressed: () {
    //     game.resourceController.addCitizen(playerNumber, planet);
    //   },
    //   anchor: Anchor.center,
    // );

    // final removeImg = game.images.fromCache('planet_citizen_remove.png');
    // final removeIcon =
    //     SpriteComponent(sprite: Sprite(removeImg), position: iconPos);
    // final removeIconDisabled =
    //     SpriteComponent(sprite: Sprite(removeImg), position: iconPos);
    // removeIconDisabled.decorator.addLast(grayTint);
    // _removeCitizen = AdvancedButtonComponent(
    //   size: iconButtonSize,
    //   position: Hex.directions[3].toPixel(),
    //   defaultSkin: RectangleComponent(
    //     paintLayers: cardSkin,
    //     children: [removeIcon],
    //   ),
    //   disabledSkin: RectangleComponent(
    //     paintLayers: textButtonDisabledPaintLayer,
    //     children: [removeIconDisabled],
    //   ),
    //   onPressed: () {
    //     game.resourceController.removeCitizen(playerNumber, planet);
    //   },
    //   anchor: Anchor.center,
    // );

    final buildImg = game.images.fromCache('planet_remove.png');
    final buildIcon =
        SpriteComponent(sprite: Sprite(buildImg), position: iconPos);
    final buildIconDisabled =
        SpriteComponent(sprite: Sprite(buildImg), position: iconPos);
    buildIconDisabled.decorator.addLast(grayTint);
    final buildText = TextComponent(
        text: 'Remove',
        textRenderer: text12,
        position: Vector2(28, 36),
        anchor: Anchor.center);
    _buildingRemoveButton = AdvancedButtonComponent(
      size: iconButtonSize,
      position: Hex.directions[0].toPixel(),
      defaultSkin: RectangleComponent(
        paintLayers: cardSkin,
        children: [buildIcon, buildText],
      ),
      disabledSkin: RectangleComponent(
        paintLayers: textButtonDisabledPaintLayer,
        children: [buildIconDisabled],
      ),
      anchor: Anchor.center,
    );

    // final upgradeImg = game.images.fromCache('planet_upgrade.png');
    // final upgradeIcon =
    //     SpriteComponent(sprite: Sprite(upgradeImg), position: iconPos);
    // final upgradeIconDisabled =
    //     SpriteComponent(sprite: Sprite(upgradeImg), position: iconPos);
    // upgradeIconDisabled.decorator.addLast(grayTint);
    // _colonyUpgradeButton = AdvancedButtonComponent(
    //   size: iconButtonSize,
    //   position: Hex.directions[4].toPixel(),
    //   defaultSkin: RectangleComponent(
    //     paintLayers: cardSkin,
    //     children: [upgradeIcon],
    //   ),
    //   disabledSkin: RectangleComponent(
    //     paintLayers: textButtonDisabledPaintLayer,
    //     children: [upgradeIconDisabled],
    //   ),
    //   onPressed: () async {
    //     final result = await game.router.pushAndWait(YesNoDialog(
    //         'Upgrade ${planet.displayName} to Level ${planet.developmentLevel + 2}?'));
    //     if (!result) {
    //       return;
    //     }

    //     game.resourceController.upgradePlanet(playerNumber, planet);
    //   },
    //   anchor: Anchor.center,
    // );

    final repairImg = game.images.fromCache('planet_repair.png');
    final repairIcon =
        SpriteComponent(sprite: Sprite(repairImg), position: iconPos);
    final repairIconDisabled =
        SpriteComponent(sprite: Sprite(repairImg), position: iconPos);
    repairIconDisabled.decorator.addLast(grayTint);
    _repairButton = AdvancedButtonComponent(
      size: iconButtonSize,
      position: Hex.directions[5].toPixel(),
      defaultSkin: RectangleComponent(
        paintLayers: cardSkin,
        children: [repairIcon],
      ),
      disabledSkin: RectangleComponent(
        paintLayers: textButtonDisabledPaintLayer,
        children: [repairIconDisabled],
      ),
      anchor: Anchor.center,
    );

    _updateAllButtons();
    planet.addListener(_updateAllButtons);

    addAll([
      _background,
      // _addCitizen,
      // _removeCitizen,
      _buildingRemoveButton,
      // _colonyUpgradeButton,
      _repairButton,
    ]);
  }

  void _addMenuNonPlayer() {}

  void _updateAllButtons() {
    // final playerNumber = game.controller.getHumanPlayerNumber();
    // _colonyUpgradeButton.isDisabled =
        // !game.resourceController.canUpgradePlanet(playerNumber, planet);
    _repairButton.isDisabled = true;
    _buildingRemoveButton.isDisabled = true;
    // _addCitizen.isDisabled = !game.resourceController.canAddCitizen(playerNumber, planet);
    // _removeCitizen.isDisabled = !game.resourceController.canRemoveCitizen(playerNumber, planet);
  }

  @override
  void onRemove() {
    planet.removeListener(_updateAllButtons);
    super.onRemove();
  }
}
