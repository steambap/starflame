import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'scifi_game.dart';
import 'add_ship_button.dart';
import 'select_control.dart';
import 'theme.dart'
    show iconButtonSize, textButtonPaintLayer, textButtonSelectedSkin;

class HudShipDeploy extends PositionComponent
    with HasGameRef<ScifiGame>, DragCallbacks {
  late final ToggleButtonComponent _deployButton;
  late final ClipComponent _clip;
  double scrollBoundsX = 0.0;

  final _clippedContent = PositionComponent();
  final List<AddShipButton> _shipButtons = [];

  @override
  Future<void> onLoad() async {
    _deployButton = ToggleButtonComponent(
        size: iconButtonSize,
        position: Vector2(4, game.size.y - iconButtonSize.y - 4),
        defaultSkin: RectangleComponent(
          size: iconButtonSize,
          paintLayers: textButtonPaintLayer,
          children: [
            SpriteComponent(
              anchor: Anchor.center,
              sprite: Sprite(game.images.fromCache("scout.png")),
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
              sprite: Sprite(game.images.fromCache("scout.png")),
              position: iconButtonSize / 2,
            ),
          ],
        ),
        onChangeState: (ButtonState selected) {
          renderButtons();
        });
    _clip = ClipComponent.rectangle(
        position: Vector2(
          _deployButton.position.x + _deployButton.size.x + 4,
          game.size.y - AddShipButton.buttonSize.y - 4,
        ),
        size: Vector2(
          game.size.x - _deployButton.position.x - 116,
          AddShipButton.buttonSize.y,
        ));
    _clip.add(_clippedContent);

    return addAll([
      _deployButton,
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

  void renderButtons() {
    _clearButtons();
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
      button.isDisabled = game.resourceController
          .canCreateShip(playerState.playerNumber, template);
      _shipButtons.add(button);
    }

    _clippedContent.addAll(_shipButtons);
    _calcScrollBounds();
    _clippedContent.x = 0;
  }

  void _clearButtons() {
    for (final element in _shipButtons) {
      element.removeFromParent();
    }
    _shipButtons.clear();
  }

  void _calcScrollBounds() {
    double contentWidth =
        _shipButtons.length * (AddShipButton.buttonSize.x + 4);
    scrollBoundsX = _clip.size.x - contentWidth;
  }
}
