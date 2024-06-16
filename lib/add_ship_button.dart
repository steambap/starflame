import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

import "scifi_game.dart";
import "theme.dart" show grayTint, cardSkin, panelBar, text12;
import "ship_hull.dart";

class AddShipButton extends PositionComponent
    with TapCallbacks, HasGameRef<ScifiGame> {
  static Vector2 buttonSize = Vector2(114, 84);

  final ShipHull hull;
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

  late final TextComponent _tName;
  late final SpriteComponent _tSprite;
  late final SpriteComponent _prodIcon;
  late final TextComponent _prodText;
  void Function(ShipHull hull)? onPressed;

  AddShipButton(this.hull, this.onPressed) : super(size: buttonSize);

  @override
  @mustCallSuper
  void onTapDown(TapDownEvent event) {
    if (_isDisabled) {
      return;
    }

    onPressed?.call(hull);
  }

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    super.onLoad();

    _tName = TextComponent(
      text: hull.name,
      position: Vector2(2, 2),
      textRenderer: text12,
    );
    final hullImg = Sprite(game.images.fromCache(hull.image));
    _tSprite = SpriteComponent(
        sprite: hullImg,
        position: Vector2(buttonSize.x / 2, 48),
        anchor: Anchor.center);

    final prodIcon = Sprite(game.images.fromCache('production_icon.png'));
    _prodIcon = SpriteComponent(sprite: prodIcon, position: Vector2(2, 68));
    _prodText = TextComponent(
      text: hull.cost.toString(),
      position: Vector2(22, 76),
      textRenderer: text12,
      anchor: Anchor.centerLeft
    );
    addAll([
      _background,
      _tName,
      _tSprite,
      _costBar,
      _prodIcon,
      _prodText,
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
