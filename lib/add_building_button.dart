import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

import "scifi_game.dart";
import "theme.dart" show grayTint, cardSkin, panelBar, text12;
import "building.dart";

class AddBuildingButton extends PositionComponent
    with TapCallbacks, HasGameRef<ScifiGame> {
  static Vector2 buttonSize = Vector2(114, 84);

  final Building building;
  final RectangleComponent _background = RectangleComponent(
    size: buttonSize,
    paintLayers: cardSkin,
  );
  final RectangleComponent _costBar = RectangleComponent(
    // Do not overlay the background border
    position: Vector2(0.5, 68),
    size: Vector2(113, 15.5),
    paint: panelBar,
  );

  late final TextComponent _buildingName;
  late final SpriteComponent _buildingSprite;
  late final SpriteComponent _costIcon;
  late final TextComponent _costText;
  void Function(Building building)? onPressed;

  AddBuildingButton(this.building, this.onPressed) : super(size: buttonSize);

  @override
  @mustCallSuper
  void onTapDown(TapDownEvent event) {
    if (_isDisabled) {
      return;
    }

    onPressed?.call(building);
  }

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    super.onLoad();

    final bdName = building.displayName.split(" ").join("\n");
    _buildingName = TextComponent(
      text: bdName,
      position: Vector2(2, 2),
      textRenderer: text12,
    );
    final buildingImg = Sprite(game.images.fromCache(building.image));
    _buildingSprite = SpriteComponent(
        sprite: buildingImg, position: Vector2(buttonSize.x / 2, 48), anchor: Anchor.center);
    _costIcon = SpriteComponent(
        sprite: Sprite(game.images.fromCache('credit_icon.png')),
        position: Vector2(2, 68));
    _costText = TextComponent(
      text: building.cost.toString(),
      position: Vector2(22, 76),
      textRenderer: text12,
      anchor: Anchor.centerLeft,
    );
    
    addAll([
      _background,
      _buildingName,
      _buildingSprite,
      _costBar,
      _costIcon,
      _costText,
    ]);
  }

  bool _isDisabled = false;

  bool get isDisabled => _isDisabled;

  set isDisabled(bool value) {
    if (_isDisabled == value) {
      return;
    }
    _isDisabled = value;
    updateRender();
  }

  @protected
  void updateRender() {
    if (isDisabled) {
      decorator.addLast(grayTint);
    } else {
      decorator.removeLast();
    }
  }
}
