import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'dart:ui' show Radius;
import 'package:flutter/painting.dart' show BorderRadius;

import "scifi_game.dart";
import "active_ability.dart";
import "active_ability_button.dart";
import 'add_ship_button.dart';
import 'select_control.dart';
import './components/cut_out_rect.dart';
import 'theme.dart'
    show
        iconButtonSize,
        btnDefaultSkin,
        btnHoverSkin,
        btnSelectedSkin,
        btnHoverAndSelectedSkin,
        icon36white;

// Container for both create ship and active ability on map
class HudMapDeploy extends PositionComponent
    with HasGameRef<ScifiGame>, DragCallbacks {
  static final buttonSize = Vector2(100, 32);
  static const topRightCut = BorderRadius.only(topRight: Radius.circular(8));
  static const bottomLeftCut =
      BorderRadius.only(bottomLeft: Radius.circular(8));
  late final ToggleButtonComponent _shipDeploy;
  late final ToggleButtonComponent _abilityToggle;
  late final ClipComponent _clip;
  double scrollBoundsX = 0.0;

  final _clippedContent = PositionComponent();
  final List<AddShipButton> _shipButtons = [];
  final List<ActiveAbilityButton> _abilityButtons = [];

  @override
  Future<void> onLoad() async {
    final shipDeploy = TextComponent(text: "\u4626", textRenderer: icon36white);
    _shipDeploy = ToggleButtonComponent(
        size: iconButtonSize,
        position: Vector2(8, game.size.y - iconButtonSize.y - 8),
        defaultLabel: shipDeploy,
        defaultSelectedLabel: shipDeploy,
        defaultSkin: CutOutRect(
          size: iconButtonSize,
          cut: bottomLeftCut,
          paintLayers: btnDefaultSkin,
        ),
        hoverSkin: CutOutRect(
          size: iconButtonSize,
          cut: bottomLeftCut,
          paintLayers: btnHoverSkin,
        ),
        defaultSelectedSkin: CutOutRect(
          size: iconButtonSize,
          cut: bottomLeftCut,
          paintLayers: btnSelectedSkin,
        ),
        hoverAndSelectedSkin: CutOutRect(
          size: iconButtonSize,
          cut: bottomLeftCut,
          paintLayers: btnHoverAndSelectedSkin,
        ),
        onSelectedChanged: (selected) {
          if (selected) {
            _renderShipButtons();
          } else {
            _clearShipButtons();
          }
        });
    final more = TextComponent(text: "\u4408", textRenderer: icon36white);
    _abilityToggle = ToggleButtonComponent(
        size: iconButtonSize,
        position: Vector2(8, game.size.y - iconButtonSize.y * 2 - 12),
        defaultLabel: more,
        defaultSelectedLabel: more,
        defaultSkin: CutOutRect(
          size: iconButtonSize,
          cut: topRightCut,
          paintLayers: btnDefaultSkin,
        ),
        hoverSkin: CutOutRect(
          size: iconButtonSize,
          cut: topRightCut,
          paintLayers: btnHoverSkin,
        ),
        defaultSelectedSkin: CutOutRect(
          size: iconButtonSize,
          cut: topRightCut,
          paintLayers: btnSelectedSkin,
        ),
        hoverAndSelectedSkin: CutOutRect(
          size: iconButtonSize,
          cut: topRightCut,
          paintLayers: btnHoverAndSelectedSkin,
        ),
        onSelectedChanged: (selected) {
          if (selected) {
            _renderAbilityButtons();
          } else {
            _clearAbilityButtons();
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
      _abilityToggle,
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
    _abilityToggle.isSelected = false;
    _clearShipButtons();

    final playerState = game.controller.getHumanPlayerState();
    final hulls = playerState.hulls;

    for (int i = 0; i < hulls.length; i++) {
      final hull = hulls[i];
      final button = AddShipButton(hull, (selectedHull) {
        game.mapGrid.selectControl =
            SelectControlCreateShip(game, selectedHull);
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

  void _renderAbilityButtons() {
    _shipDeploy.isSelected = false;
    _clearAbilityButtons();

    int i = 0;
    for (final abEntry in abilities.entries) {
      final ab = abEntry.key;
      final aa = abEntry.value;
      if (aa.isShow(game) == false) {
        continue;
      }

      final button = ActiveAbilityButton(
        ab,
        size: buttonSize,
        defaultLabel: aa.getLabel(game),
        defaultSkin: CutOutRect(size: buttonSize, paintLayers: btnDefaultSkin),
        hoverSkin: CutOutRect(size: buttonSize, paintLayers: btnHoverSkin),
        onPressed: () {
          game.mapGrid.selectControl = SelectControlUseAbility(aa, game);
        },
      );
      button.position.x = i * (buttonSize.x + 8);
      _abilityButtons.add(button);
      i++;
    }

    _addContent(_abilityButtons);
  }

  void _clearShipButtons() {
    for (final element in _shipButtons) {
      element.removeFromParent();
    }
    _shipButtons.clear();
  }

  void _clearAbilityButtons() {
    for (final element in _abilityButtons) {
      element.removeFromParent();
    }
    _abilityButtons.clear();
  }

  void minimize() {
    _shipDeploy.isSelected = false;
    _abilityToggle.isSelected = false;
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
    if (_abilityToggle.isSelected) {
      _renderAbilityButtons();
    }
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
