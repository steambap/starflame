import 'package:flame/components.dart';
import 'package:flame/events.dart';
import "package:intl/intl.dart" show toBeginningOfSentenceCase;

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
  final _foodLabel = TextComponent(
      text: "Food",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 40));
  final _foodValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 40));
  final _tradeLabel = TextComponent(
      text: "Trade",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 68));
  final _tradeValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 68));
  final _supportLabel = TextComponent(
      text: "Support",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 96));
  final _supportValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 96));
  final _buildingLabel = TextComponent(
      text: "Building",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 124));
  final _buildingValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 124));
  final _citizenLabel = TextComponent(
      text: "Citizen",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 152));
  final _citizenValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 152));
  final _lifeQualityLabel = TextComponent(
      text: "Life Quality",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 180));
  final _lifeQualityValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 180));
  final _growthLabel = TextComponent(
      text: "Growth",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 208));
  final _growthValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 208));
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
      _foodLabel,
      _foodValue,
      _tradeLabel,
      _tradeValue,
      _citizenLabel,
      _citizenValue,
      _defenseLabel,
      _defenseValue,
      _growthLabel,
      _growthValue,
      _lifeQualityLabel,
      _lifeQualityValue,
      _supportLabel,
      _supportValue,
      _buildingLabel,
      _buildingValue,
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

  void updateRender(Planet? planet) {
    if (planet == null) {
      isVisible = false;
      for (final element in _buildingTexts) {
        element.removeFromParent();
      }
      _buildingTexts.clear();
      return;
    }

    isVisible = true;
    _setText(planet);
    _calcScrollBounds();
    _clippedContent.y = 0;
  }

  void _setText(Planet planet) {
    _planetName.text =
        "${planet.displayName} Lv.${planet.developmentLevel + 1}";
    _foodValue.text = "${planet.food}/${planet.type.food}";
    _tradeValue.text = "${planet.trade}";
    _citizenValue.text = "${planet.citizen}";
    _defenseValue.text = "${planet.defense} / ${planet.defenseMax()}";
    _growthValue.text = "${planet.growth()}";
    _supportValue.text = "${planet.support}(${planet.calcSupport()})";
    _lifeQualityValue.text = "${planet.lifeQuality()}";
    _buildingValue.text = "${planet.buildings.length}/${planet.maxBuilding()}";
    _planetTypeLabel.text = toBeginningOfSentenceCase(planet.type.name);
    _planetSizeLabel.text = planet.planetSizeStr();

    _buildingTitle.text =
        "Buildings (${planet.buildings.length}/${planet.maxBuilding()})";
    for (int i = 0; i < planet.buildings.length; i++) {
      final building = planet.buildings[i];
      final text = TextComponent(
        text: building.displayName,
        textRenderer: text12,
        anchor: Anchor.centerLeft,
        position: Vector2(8, 324 + i * 28),
      );
      _buildingTexts.add(text);
    }

    _clippedContent.addAll(_buildingTexts);
  }

  void _calcScrollBounds() {
    double contentHeight = _infoBackground.size.y + _buildingList.size.y + 8;

    scrollBoundsY = _clip.size.y - contentHeight;
  }
}
