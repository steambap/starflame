import 'package:flame/components.dart';
import 'package:flame/events.dart';
import "package:intl/intl.dart" show toBeginningOfSentenceCase;

import "sim_props.dart";
import "scifi_game.dart";
import "planet.dart";
import "theme.dart" show text12, text16;

class HudPlanetInfo extends PositionComponent
    with HasGameRef<ScifiGame>, HasVisibility, DragCallbacks {
  // Scrollable on mobile
  final _clip = ClipComponent.rectangle(
    position: Vector2(0, 36),
  );
  double scrollBoundsY = 0.0;
  final _clippedContent = PositionComponent();

  late final SpriteComponent _infoBackground;
  late final SpriteComponent _buildingList;
  // Basic info
  final _planetName = TextComponent(
      textRenderer: text16, anchor: Anchor.topLeft, position: Vector2.all(4));
  final _line1Label = TextComponent(
      text: "Production",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 40));
  final _line1Value = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 40));
  final _line2Label = TextComponent(
      text: "Credit",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 68));
  final _line2Value = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 68));
  final _line3Label = TextComponent(
      text: "Science",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 96));
  final _line3Value = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 96));
  final _line4Label = TextComponent(
      text: "Maintaince",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 124));
  final _line4Value = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 124));
  // final _citizenLabel = TextComponent(
  //     text: "Citizen",
  //     textRenderer: text12,
  //     anchor: Anchor.centerLeft,
  //     position: Vector2(8, 152));
  // final _citizenValue = TextComponent(
  //     text: "0",
  //     textRenderer: text12,
  //     anchor: Anchor.centerRight,
  //     position: Vector2(192, 152));
  // final _lifeQualityLabel = TextComponent(
  //     text: "Life Quality",
  //     textRenderer: text12,
  //     anchor: Anchor.centerLeft,
  //     position: Vector2(8, 180));
  // final _lifeQualityValue = TextComponent(
  //     text: "0",
  //     textRenderer: text12,
  //     anchor: Anchor.centerRight,
  //     position: Vector2(192, 180));
  // final _growthLabel = TextComponent(
  //     text: "Growth",
  //     textRenderer: text12,
  //     anchor: Anchor.centerLeft,
  //     position: Vector2(8, 208));
  // final _growthValue = TextComponent(
  //     text: "0",
  //     textRenderer: text12,
  //     anchor: Anchor.centerRight,
  //     position: Vector2(192, 208));
  final _defenseLabel = TextComponent(
      text: "Defense",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 236));
  final _defenseValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 236));
  final _planetTypeLabel = TextComponent(
      text: "terran",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 264));
  final _planetSizeLabel = TextComponent(
      text: "medium",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 264));
  // Building list
  final _buildingTitle = TextComponent(
      textRenderer: text16, anchor: Anchor.topLeft, position: Vector2(4, 288));
  final List<TextComponent> _buildingTexts = [];

  HudPlanetInfo() : super(anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    size = Vector2(200, game.size.y - 40);
    _clip.size = size;
    isVisible = false;

    final bgImg = game.images.fromCache("planet_info.png");
    _infoBackground = SpriteComponent(sprite: Sprite(bgImg));
    final buildingImg = game.images.fromCache("planet_building.png");
    _buildingList =
        SpriteComponent(sprite: Sprite(buildingImg), position: Vector2(0, 284));

    add(_clip);
    _clip.add(_clippedContent);
    _clippedContent.addAll([
      _infoBackground,
      _buildingList,
      _planetName,
      _line1Label,
      _line1Value,
      _line2Label,
      _line2Value,
      _line3Label,
      _line3Value,
      // _citizenLabel,
      // _citizenValue,
      _defenseLabel,
      _defenseValue,
      // _growthLabel,
      // _growthValue,
      // _lifeQualityLabel,
      // _lifeQualityValue,
      _line4Label,
      _line4Value,
      _planetTypeLabel,
      _planetSizeLabel,
      _buildingTitle,
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    if (isVisible) {
      return super.containsLocalPoint(point);
    }

    return false;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (scrollBoundsY < 0) {
      _clippedContent.y += event.localDelta.y;
      _clippedContent.y = _clippedContent.y.clamp(scrollBoundsY, 0);
    }
  }

  void hide() {
    isVisible = false;
    for (final element in _buildingTexts) {
      element.removeFromParent();
    }
    _buildingTexts.clear();
  }

  void show(Planet planet) {
    isVisible = true;
    _setText(planet);
    _calcScrollBounds();
    _clippedContent.y = 0;
  }

  void updateRender(Planet planet) {
    _setText(planet);
  }

  void _setText(Planet planet) {
    _planetName.text = planet.displayName;
    _line1Value.text = "${planet.getProp(SimProps.production).toInt()}";
    _line2Value.text = "${planet.getProp(SimProps.credit).toInt()}";
    _line3Value.text = "${planet.getProp(SimProps.science).toInt()}";
    _line4Value.text = "${planet.getProp(SimProps.maintainceCost).toInt()}";

    _defenseValue.text = "${planet.defense}/${planet.defenseMax()}";
    // _growthValue.text = "${planet.growth()}";
    // _supportValue.text = "${planet.support}(${planet.calcSupport()})";
    // _lifeQualityValue.text = "${planet.lifeQuality()}";
    _planetTypeLabel.text = toBeginningOfSentenceCase(planet.type.name);
    _planetSizeLabel.text = planet.planetSizeStr();

    _clippedContent.addAll(_buildingTexts);
  }

  void _calcScrollBounds() {
    double contentHeight = _infoBackground.size.y + _buildingList.size.y + 8;

    scrollBoundsY = _clip.size.y - contentHeight;
  }
}
