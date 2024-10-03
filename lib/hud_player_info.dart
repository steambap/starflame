import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';

import 'scifi_game.dart';
import "styles.dart";
import "async_updated_ui.dart";
import "components/row_container.dart";

class HudPlayerInfo extends PositionComponent
    with HasGameRef<ScifiGame>, AsyncUpdatedUi {
  final _panel =
      RectangleComponent(paintLayers: panelSkin, position: Vector2(-0.5, 0));
  final RowContainer _resourceRow =
      RowContainer(size: Vector2(0, navbarHeight));
  final RowContainer _statusRow = RowContainer(size: Vector2(0, navbarHeight));

  final _empireColor =
      RectangleComponent(size: Vector2(24, 24), position: Vector2(4, 4));

  final TextComponent _supportIcon =
      TextComponent(text: "\u49c9", textRenderer: icon16purple);
  final _supportLabel = TextComponent(text: "0", textRenderer: text12);

  final TextComponent _productionIcon =
      TextComponent(text: "\u4a95", textRenderer: icon16red);
  final _productionLabel = TextComponent(text: "0", textRenderer: text12);

  final TextComponent _creditIcon =
      TextComponent(text: "\u3fde", textRenderer: icon16yellow);
  final _creditLabel = TextComponent(text: "0", textRenderer: text12);

  final TextComponent _scienceIcon =
      TextComponent(text: "\u48bb", textRenderer: icon16blue);
  final _scienceLabel = TextComponent(text: "0", textRenderer: text12);

  final _supportLabel2 =
      TextComponent(text: "Next Action Cost: 1", textRenderer: text12);
  final TextComponent _supportIcon2 =
      TextComponent(text: "\u49c9", textRenderer: icon16purple);

  HudPlayerInfo();

  @override
  FutureOr<void> onLoad() {
    _resourceRow.addAll([
      _empireColor,
      _supportIcon,
      _supportLabel,
      _productionIcon,
      _productionLabel,
      _creditIcon,
      _creditLabel,
      _scienceIcon,
      _scienceLabel,
    ]);
    _statusRow.addAll([
      _supportLabel2,
      _supportIcon2,
    ]);
    _statusRow.layout();

    addAll([
      _panel,
      _resourceRow,
      _statusRow,
    ]);

    addListener();
  }

  @override
  void onGameResize(Vector2 size) {
    position = Vector2(0, size.y - navbarHeight + 0.5);
    _panel.size = Vector2(size.x + 1, navbarHeight);
    _statusRow.position = Vector2(size.x - _statusRow.size.x - 124, 0);
    super.onGameResize(size);
  }

  void addListener() {
    game.controller.getHumanPlayerState().addListener(scheduleUpdate);
    scheduleUpdate();
  }

  void removeListener() {
    game.controller.getHumanPlayerState().removeListener(scheduleUpdate);
  }

  @override
  void updateRender() {
    final playerState = game.controller.getHumanPlayerState();
    _empireColor.paint = Paint()..color = playerState.color;
    final income = game.resourceController.humanPlayerIncome();
    _supportLabel.text = "${playerState.support}+${income.support}";
    _creditLabel.text =
        "${playerState.credit.toInt()}+${income.credit.toInt()}";
    _productionLabel.text = "${playerState.production}+${income.production}";
    _scienceLabel.text = "${playerState.science}+${income.science}";
    _supportLabel2.text = "Next Action Cost: ${playerState.nextActionCost}";

    _resourceRow.layout();
    _statusRow.layout();
  }

  @override
  void onRemove() {
    removeListener();
    super.onRemove();
  }
}
