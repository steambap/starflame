import 'package:flame/components.dart';
import 'package:flame/events.dart';

import "scifi_game.dart";
import "add_building_button.dart";
import "building.dart";
import 'add_ship_button.dart';
import 'select_control.dart';
import 'theme.dart'
    show iconButtonSize, textButtonPaintLayer, textButtonSelectedSkin;

// Container for both create ship and add building on map
class HudMapDeploy extends PositionComponent
    with HasGameRef<ScifiGame>, DragCallbacks {
  late final ToggleButtonComponent _shipDeploy;
  late final ToggleButtonComponent _buildingDeploy;
  late final ClipComponent _clip;
  double scrollBoundsX = 0.0;

  final _clippedContent = PositionComponent();
  final List<AddShipButton> _shipButtons = [];
  final List<AddBuildingButton> _buildingButtons = [];

  @override
  Future<void> onLoad() async {
    final shipDeploy = Sprite(game.images.fromCache("ship_deploy.png"));
    _shipDeploy = ToggleButtonComponent(
        size: iconButtonSize,
        position: Vector2(4, game.size.y - iconButtonSize.y - 4),
        defaultSkin: RectangleComponent(
          size: iconButtonSize,
          paintLayers: textButtonPaintLayer,
          children: [
            SpriteComponent(
              anchor: Anchor.center,
              sprite: shipDeploy,
              position: iconButtonSize / 2,
            ),
          ],
        ),
        defaultSelectedSkin: RectangleComponent(
          size: iconButtonSize,
          paintLayers: textButtonSelectedSkin,
          children: [
            SpriteComponent(
              anchor: Anchor.center,
              sprite: shipDeploy,
              position: iconButtonSize / 2,
            ),
          ],
        ),
        onSelectedChanged: (selected) {
          if (selected) {
            _renderShipButtons();
          } else {
            _clearShipButtons();
          }
        });
    final crane = Sprite(game.images.fromCache("crane.png"));
    _buildingDeploy = ToggleButtonComponent(
        size: iconButtonSize,
        position: Vector2(4, game.size.y - iconButtonSize.y * 2 - 8),
        defaultSkin: RectangleComponent(
          size: iconButtonSize,
          paintLayers: textButtonPaintLayer,
          children: [
            SpriteComponent(
              anchor: Anchor.center,
              sprite: crane,
              position: iconButtonSize / 2,
            ),
          ],
        ),
        defaultSelectedSkin: RectangleComponent(
          size: iconButtonSize,
          paintLayers: textButtonSelectedSkin,
          children: [
            SpriteComponent(
              anchor: Anchor.center,
              sprite: crane,
              position: iconButtonSize / 2,
            ),
          ],
        ),
        onSelectedChanged: (selected) {
          if (selected) {
            _renderBuildingButtons();
          } else {
            _clearBuildingButtons();
          }
        });
    _clip = ClipComponent.rectangle(
        position: Vector2(
          _shipDeploy.position.x + _shipDeploy.size.x + 4,
          game.size.y - AddShipButton.buttonSize.y - 4,
        ),
        size: Vector2(
          game.size.x - _shipDeploy.position.x - 116,
          AddShipButton.buttonSize.y,
        ));
    _clip.add(_clippedContent);

    return addAll([
      _shipDeploy,
      _buildingDeploy,
      _clip,
    ]);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (scrollBoundsX < 0) {
      _clippedContent.x += event.localDelta.x;
      _clippedContent.x = _clippedContent.x.clamp(scrollBoundsX, 0);
    }
  }

  void _renderShipButtons() {
    _buildingDeploy.isSelected = false;
    _clearShipButtons();

    final playerState = game.controller.getHumanPlayerState();
    final ts = playerState.templates;

    for (int i = 0; i < ts.length; i++) {
      final template = ts[i];
      final button = AddShipButton(template, (template) {
        game.mapGrid.selectControl = SelectControlCreateShip(game, template);
      });
      button.position = Vector2(
        i * (AddShipButton.buttonSize.x + 4),
        0,
      );
      button.isDisabled = !game.resourceController
          .canCreateShip(playerState.playerNumber, template);
      _shipButtons.add(button);
    }

    _addContent(_shipButtons);
  }

  void _renderBuildingButtons() {
    _shipDeploy.isSelected = false;
    _clearBuildingButtons();

    final playerNumber = game.controller.getHumanPlayerNumber();

    for (int i = 0; i < Building.values.length; i++) {
      final bd = Building.values[i];
      final button = AddBuildingButton(bd, (building) {
        game.mapGrid.selectControl = SelectControlAddBuilding(building, game);
      });
      button.isDisabled =
          !game.resourceController.canAffordBuilding(playerNumber, bd);
      button.position = Vector2((AddBuildingButton.buttonSize.x + 4) * i, 0);
      _buildingButtons.add(button);
    }

    _addContent(_buildingButtons);
  }

  void _clearShipButtons() {
    for (final element in _shipButtons) {
      element.removeFromParent();
    }
    _shipButtons.clear();
  }

  void _clearBuildingButtons() {
    for (final element in _buildingButtons) {
      element.removeFromParent();
    }
    _buildingButtons.clear();
  }

  void minimize() {
    _shipDeploy.isSelected = false;
    _buildingDeploy.isSelected = false;
  }

  void _addContent(Iterable<Component> components) {
    _clippedContent.addAll(components);
    _calcScrollBounds();
    _clippedContent.x = 0;
  }

  void _calcScrollBounds() {
    double contentWidth =
        _shipButtons.length * (AddShipButton.buttonSize.x + 4);
    scrollBoundsX = _clip.size.x - contentWidth;
  }

  void updateRender() {
    final playerNumber = game.controller.getHumanPlayerNumber();
    for (final button in _buildingButtons) {
      button.isDisabled = !game.resourceController
          .canAffordBuilding(playerNumber, button.building);
    }
    for (final button in _shipButtons) {
      button.isDisabled =
          !game.resourceController.canCreateShip(playerNumber, button.template);
    }
  }

  void addListener() {
    game.controller.getHumanPlayerState().addListener(updateRender);
    updateRender();
  }

  @override
  void onRemove() {
    game.controller.getHumanPlayerState().removeListener(updateRender);
  }
}
