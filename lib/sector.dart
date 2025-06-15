import 'dart:async';
import 'dart:ui' show Paint;
import "package:collection/collection.dart";
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import "hex.dart";
import "sim_props.dart";
import 'scifi_game.dart';
import "player_state.dart";
import "planet.dart";
import "star.dart";
import "styles.dart";
import "building.dart";

class Sector extends PositionComponent
    with HasGameReference<ScifiGame>, ChangeNotifier, SimObject {
  static const output = 10;

  int? playerNumber;
  int team = 0;

  int homePlanet = -1;

  final Hex hex;
  final StarType starType;
  final TextComponent _nameLabel = TextComponent(
      text: "",
      position: Vector2(0, 24),
      anchor: Anchor.center,
      textRenderer: FlameTheme.text16pale);
  final RectangleComponent _nameBG = RectangleComponent(
      size: Vector2(108, 24),
      position: Vector2(0, 24),
      paintLayers: FlameTheme.labelBackground,
      anchor: Anchor.center);
  late final SpriteComponent _star;
  final List<Building?> buildings = List.filled(6, null);

  List<Planet> planets;
  final List<CircleComponent> _planetCircles = [];

  Sector(this.hex, this.starType, {this.planets = const []});

  String _displayName = "";
  String get displayName => _displayName;
  set displayName(String value) {
    _displayName = value;

    int surfix = 1;
    for (final p in planets) {
      if (!p.isUnique) {
        final roman = getRomanNumeral(surfix);
        p.name = "$displayName $roman";
        surfix += 1;
      }
    }
  }

  @override
  FutureOr<void> onLoad() {
    _nameLabel.text = displayName;
    final starImgName = switch (starType) {
      StarType.binary => 'binary_star.png',
      StarType.none => 'none.png',
      StarType.blue => 'blue_star.png',
      StarType.red => 'red_star.png',
      StarType.yellow => 'yellow_star.png',
      StarType.white => 'white_star.png',
    };
    final starImg = game.images.fromCache(starImgName);
    _star = SpriteComponent(sprite: Sprite(starImg), anchor: Anchor.center);

    final dx = (planets.length ~/ 2) + 1;
    final planetCirclesStart = 8 - (dx * 8.0 + (dx - 1) * 2);
    for (int i = 0; i < planets.length; i++) {
      final isSecondRow = i % 2 == 1;
      final pos =
          Vector2(0, isSecondRow ? -16 : -36 // Adjust Y position for second row
              );
      final circle = CircleComponent(
          radius: 8,
          position: Vector2(planetCirclesStart + i * 10, 0) + pos,
          paint: FlameTheme.planetInhabitable,
          anchor: Anchor.center);
      _planetCircles.add(circle);
    }

    _nameBG.size.x = _nameLabel.size.x + 4;

    addAll([
      _nameBG,
      ..._planetCircles,
      if (starType != StarType.none) _star,
      _nameLabel,
    ]);

    refreshProps();
    updateRender();
  }

  void setHome(PlayerState playerState) {
    playerNumber = playerState.playerNumber;
    homePlanet = playerState.playerNumber;

    for (final planet in planets) {
      if (planet.type == PlanetType.habitable) {
        planet.isColonized = true;
      }
    }

    refreshProps();
  }

  bool isHome() {
    return homePlanet == playerNumber;
  }

  void colonize(int playerNumber) {
    this.playerNumber = playerNumber;
    updateRender();
    notifyListeners();
  }

  void capture(int playerNumber) {
    this.playerNumber = playerNumber;
    updateRender();
  }

  void updateRender() {
    final pState = playerNumber != null
        ? game.controller.getPlayerState(playerNumber!)
        : game.controller.getHumanPlayerState();

    if (playerNumber == null) {
      _nameBG.paintLayers = FlameTheme.labelBackground;
    } else {
      _nameBG.paintLayers = pState.paintLayer;
    }

    for (int i = 0; i < _planetCircles.length; i++) {
      final planet = planets[i];
      final circle = _planetCircles[i];
      circle.paint = getPlanetPaint(planet.type);
    }
  }

  Iterable<Planet> getHabitablePlanets() {
    return planets.where((p) => p.type == PlanetType.habitable);
  }

  Iterable<Planet> getInhabitablePlanets() {
    return planets.where((p) => p.type == PlanetType.inhabitable);
  }

  void phaseUpdate(int playerNumber) {
    if (this.playerNumber != playerNumber) {
      return;
    }

    updateRender();
  }

  bool isBlocked(int playerNumber) {
    if (neutral()) {
      return false;
    }

    // Maybe add a healthbar for sector?
    return this.playerNumber != playerNumber && false;
  }

  bool neutral() {
    return playerNumber == null;
  }

  int getBuildingCount() {
    return buildings.where((b) => b != null).length;
  }

  void refreshProps() {
    props.clear();

    for (final planet in planets) {
      if (planet.isColonized) {
        addProp(SimProps.production, 2);
      }
    }

    addProp(SimProps.energy, output);
    addProp(SimProps.politics, output);

    final maintaince = isHome() ? 0 : 2;
    addProp(SimProps.energy, -maintaince);
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      if (playerNumber != null) "playerNumber": playerNumber,
      "homePlanet": homePlanet,
      "displayName": displayName,
      "hex": hex.toInt(),
      "starType": starType.name,
      "buildings": buildings.map((b) => b?.toJson()).toList(),
    };
  }

  static String getRomanNumeral(int number) {
    const romanNumerals = [
      "I",
      "II",
      "III",
      "IV",
      "V",
      "VI",
      "VII",
      "VIII",
      "IX",
      "X"
    ];
    if (number < 1 || number > 10) {
      return number.toString();
    }
    return romanNumerals[number - 1];
  }

  static Paint getPlanetPaint(PlanetType t) {
    if (t == PlanetType.habitable) {
      return FlameTheme.planetHabitable;
    }

    return FlameTheme.planetInhabitable;
  }
}
