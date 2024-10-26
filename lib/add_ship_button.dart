import 'package:flame/components.dart';

import "scifi_game.dart";
import "styles.dart";
import "ship_blueprint.dart";
import "components/advanced_button.dart";

class AddShipButton extends AdvancedButton with HasGameRef<ScifiGame> {
  static Vector2 buttonSize = Vector2(114, 84);

  final ShipBlueprint blueprint;

  late final TextComponent _tName;
  late final SpriteComponent _tSprite;
  final TextComponent _prodIcon = TextComponent(
      position: Vector2(2, 68),
      text: "\ue1b1",
      textRenderer: icon16red,
      priority: 1);
  late final TextComponent _prodText;

  AddShipButton(this.blueprint, {super.onReleased}) : super(size: buttonSize);

  @override
  Future<void> onLoad() async {
    _tName = TextComponent(
      text: blueprint.className,
      position: Vector2(2, 2),
      textRenderer: label12,
      priority: 1,
    );

    final hullImg = Sprite(game.images.fromCache(blueprint.image));
    _tSprite = SpriteComponent(
        sprite: hullImg,
        position: Vector2(buttonSize.x / 2, 48),
        anchor: Anchor.center);
    defaultLabel = _tSprite;
    defaultSkin =
        RectangleComponent(size: buttonSize, paintLayers: shipBtnSkin);
    hoverSkin =
        RectangleComponent(size: buttonSize, paintLayers: shipBtnHoverSkin);
    disabledSkin =
        RectangleComponent(size: buttonSize, paintLayers: shipBtnDisabledSkin);

    _prodText = TextComponent(
        text: blueprint.cost.toString(),
        position: Vector2(22, 76),
        textRenderer: label12,
        priority: 1,
        anchor: Anchor.centerLeft);
    addAll([
      _tName,
      _prodIcon,
      _prodText,
    ]);

    return super.onLoad();
  }
}
