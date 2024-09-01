import 'package:flame/components.dart';
import 'package:flame/events.dart';

import "scifi_game.dart";
import 'add_ship_button.dart';
import 'select_control.dart';

// Container for both create ship and active ability on map
class HudMapDeploy extends PositionComponent
    with HasGameRef<ScifiGame>, DragCallbacks {
  late final ClipComponent _clip;
  double scrollBoundsX = 0.0;

  final _clippedContent = PositionComponent();
  final List<AddShipButton> _shipButtons = [];

  @override
  Future<void> onLoad() async {
    _clip = ClipComponent.rectangle(
        position: Vector2(
          8,
          game.size.y - AddShipButton.buttonSize.y - 8,
        ),
        size: Vector2(
          game.size.x - 200,
          AddShipButton.buttonSize.y,
        ));
    _clip.add(_clippedContent);

    return addAll([
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

  void renderShipButtons() {
    clearShipButtons();

    final playerState = game.controller.getHumanPlayerState();
    final hulls = playerState.hulls;

    for (int i = 0; i < hulls.length; i++) {
      final hull = hulls[i];
      final button = AddShipButton(hull, onReleased: () {
        game.mapGrid.selectControl =
            SelectControlCreateShip(game, hull);
      });
      button.position = Vector2(
        i * (AddShipButton.buttonSize.x + 4),
        0,
      );
      button.isDisabled = !game.resourceController
          .canCreateShip(playerState.playerNumber, hull);
      _shipButtons.add(button);
    }

    _addContent(_shipButtons);
  }

  void clearShipButtons() {
    for (final element in _shipButtons) {
      element.removeFromParent();
    }
    _shipButtons.clear();
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

    for (final button in _shipButtons) {
      button.isDisabled =
          !game.resourceController.canCreateShip(playerNumber, button.hull);
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
