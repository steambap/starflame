import 'package:flame/components.dart';
import "package:intl/intl.dart" show toBeginningOfSentenceCase;

import "scifi_game.dart";
import "planet.dart";
import "theme.dart" show text12, text16;

class HudPlanetInfo extends PositionComponent
    with HasGameRef<ScifiGame>, HasVisibility {
  late final SpriteComponent _background;

  final _planetName = TextComponent(
      textRenderer: text16, anchor: Anchor.topLeft, position: Vector2.all(12));
  final _energyLabel = TextComponent(
      text: "Energy",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(16, 48));
  final _energyValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(200, 48));
  final _energyIncome = TextComponent(
      text: "Income",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(16, 75));
  final _metalLabel = TextComponent(
      text: "Metal",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(16, 101));
  final _metalValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(200, 101));
  final _metalIncome = TextComponent(
      text: "Income",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(16, 127));
  final _defenseLabel = TextComponent(
      text: "Defense",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(16, 153));
  final _defenseValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(200, 153));
  final _populationLabel = TextComponent(
      text: "Population",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(16, 180));
  final _populationValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(200, 180));
  final _growthLabel = TextComponent(
      text: "Growth",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(16, 206));
  final _growthValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(200, 206));
  final _supportLabel = TextComponent(
      text: "Support",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(16, 233));
  final _supportValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(200, 233));
  final _facilityLabel = TextComponent(
      text: "Facility",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(16, 259));
  final _facilityValue = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(200, 259));
  final _planetTypeLabel = TextComponent(
      text: "terran",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(16, 285));
  final _planetSizeLabel = TextComponent(
      text: "medium",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(200, 285));
  final _colonyTypeLabel = TextComponent(
      text: "none",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(16, 311));

  HudPlanetInfo() : super(anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    isVisible = false;

    final img = game.images.fromCache("planet_info.png");
    _background = SpriteComponent(sprite: Sprite(img), position: Vector2.all(8));

    addAll([
      _background,
      _planetName,
      _energyLabel,
      _energyValue,
      _energyIncome,
      _metalLabel,
      _metalValue,
      _metalIncome,
      _defenseLabel,
      _defenseValue,
      _populationLabel,
      _populationValue,
      _growthLabel,
      _growthValue,
      _supportLabel,
      _supportValue,
      _facilityLabel,
      _facilityValue,
      _planetTypeLabel,
      _planetSizeLabel,
    ]);
  }

  void updateRender(Planet? planet) {
    if (planet == null) {
      isVisible = false;
      return;
    }

    isVisible = true;
    _setText(planet);
  }

  void _setText(Planet planet) {
    _planetName.text = planet.displayName;
    _energyValue.text =
        "${planet.energy.toInt()}/${planet.energyMax().toInt()}";
    _energyIncome.text = "⌙ Income: ${planet.energyIncome().toInt()}";
    _metalValue.text = "${planet.metal.toInt()}/${planet.metalMax().toInt()}";
    _metalIncome.text = "⌙ Income: ${planet.metalIncome().toInt()}";
    _defenseValue.text =
        "${planet.defense.toInt()}/${planet.defenseMax().toInt()}";
    _populationValue.text = "${planet.population}/${planet.maxPop()}";
    _growthValue.text =
        "${planet.currentGrowth.toStringAsFixed(1)}/100";
    _supportValue.text = "${planet.support()}";
    _facilityValue.text = "${planet.facilities.length}/${planet.maxFacilities()}";
    _planetTypeLabel.text = toBeginningOfSentenceCase(planet.type.name);
    _planetSizeLabel.text = planet.planetSizeStr();
    _colonyTypeLabel.text = planet.colonyTypeEffectStr();
  }
}
