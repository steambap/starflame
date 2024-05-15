import 'dart:async';
import 'package:flame/components.dart';

import 'scifi_game.dart';
import 'ship.dart';
import 'theme.dart'
    show text16, text12, iconButtonSize, panelBackground, cardSkin;
import 'action_button.dart';
import 'components/text_component_clipped.dart';

class HudShipCommand extends PositionComponent
    with HasGameRef<ScifiGame>, HasVisibility {
  static final panelSize = Vector2(280, 112);
  static final textSize = Vector2(192, 24);
  static final rectSize = Vector2(188, 24);
  late final RectangleComponent _shipInfoBackground;
  late final SpriteComponent _shipImage;
  final TextComponent _shipAndTemplateName =
      TextComponent(textRenderer: text16, anchor: Anchor.centerLeft);
  final TextComponent _shipLifeAndArmor =
      TextComponent(textRenderer: text12, anchor: Anchor.centerLeft);
  final TextComponent _shipMoveAndVision =
      TextComponent(textRenderer: text12, anchor: Anchor.centerLeft);
  final TextComponentClipped _shipItems =
      TextComponentClipped(rectSize, textRenderer: text12, anchor: Anchor.centerLeft);

  final List<ActionButton> _shipCommandButtons = [];

  Ship? _ship;
  bool _isScheduled = false;

  @override
  FutureOr<void> onLoad() {
    // start invisible and only shows if a ship is selected
    isVisible = false;
    _shipInfoBackground = RectangleComponent(
        size: panelSize,
        paint: panelBackground,
        position: Vector2(0, game.size.y - panelSize.y),
        children: [
          RectangleComponent(
              size: textSize, paintLayers: cardSkin, position: Vector2(84, 28)),
          RectangleComponent(
              size: textSize, paintLayers: cardSkin, position: Vector2(84, 56)),
          RectangleComponent(
              size: textSize, paintLayers: cardSkin, position: Vector2(84, 84)),
        ]);

    final sprite = Sprite(game.images.fromCache("scout.png"));
    final shipImagePos = _shipInfoBackground.position + Vector2(42, 70);
    _shipImage = SpriteComponent(
        sprite: sprite, anchor: Anchor.center, position: shipImagePos);

    _shipAndTemplateName.position = Vector2(4, _shipInfoBackground.y + 14);
    _shipLifeAndArmor.position = Vector2(86, _shipInfoBackground.y + 40);
    _shipMoveAndVision.position = Vector2(86, _shipInfoBackground.y + 68);
    _shipItems.position = Vector2(86, _shipInfoBackground.y + 96);

    return addAll([
      _shipInfoBackground,
      _shipImage,
      _shipAndTemplateName,
      _shipLifeAndArmor,
      _shipMoveAndVision,
      _shipItems,
    ]);
  }

  @override
  void onRemove() {
    _ship?.removeListener(_scheduleUpdateRender);
    super.onRemove();
  }

  void updateRender(Ship? ship) {
    _ship?.removeListener(_scheduleUpdateRender);
    if (ship != null) {
      ship.addListener(_scheduleUpdateRender);
    }
    _ship = ship;
    _scheduleUpdateRender();
  }

  void _scheduleUpdateRender() {
    if (_isScheduled) {
      return;
    }
    _isScheduled = true;

    Future.delayed(const Duration(milliseconds: 100), () {
      _isScheduled = false;
      _updateRender();
    });
  }

  void _updateRender() {
    if (_ship != null) {
      _renderShip(_ship!);
      isVisible = true;
    } else {
      _clearActions();
      isVisible = false;
    }
  }

  void _renderShip(Ship ship) {
    final state = ship.state;
    _shipAndTemplateName.text =
        "${ship.template.hull.name}/${ship.template.name}";
    _shipLifeAndArmor.text =
        "HP: ${state.health}/${ship.template.maxHealth()}; Armor: ${ship.template.hull.armor}";
    _shipMoveAndVision.text =
        "Move: ${ship.movePoint()}/${ship.template.maxMove()}";
    _shipItems.text = ship.template.items.map((e) => e.name).join(", ");
    _shipImage.sprite = Sprite(game.images.fromCache(ship.template.hull.image));
    _clearActions();

    final playerIdx = game.controller.getHumanPlayerNumber();
    if (playerIdx == ship.state.playerNumber) {
      final actions = ship.template.actions();
      for (int i = 0; i < actions.length; i++) {
        final aButton = ActionButton(ship.cell, actions[i]);
        aButton.position = Vector2(4,
            _shipInfoBackground.position.y - (i + 1) * (iconButtonSize.y + 4));
        _shipCommandButtons.add(
          aButton,
        );
      }
      addAll(_shipCommandButtons);
    }

    isVisible = true;
  }

  void _clearActions() {
    for (final element in _shipCommandButtons) {
      element.removeFromParent();
    }
    _shipCommandButtons.clear();
  }
}
