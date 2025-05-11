import 'dart:async';
import 'dart:ui' show Paint;
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import "hex.dart";
import "sim_props.dart";
import 'scifi_game.dart';
import "player_state.dart";
import "planet.dart";
import "star.dart";
import "styles.dart";

class Sector extends PositionComponent
    with HasGameRef<ScifiGame>, ChangeNotifier, SimObject {
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

    final planetCirclesStart =
        8 - (planets.length * 8.0 + (planets.length - 1) * 2);
    for (int i = 0; i < planets.length; i++) {
      final circle = CircleComponent(
          radius: 8,
          position: Vector2(planetCirclesStart + i * 20, -24),
          paintLayers: FlameTheme.planetGas,
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

    refreshProps();
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

    final playerPaintLayer = [Paint()..color = pState.color];

    for (int i = 0; i < _planetCircles.length; i++) {
      final planet = planets[i];
      final circle = _planetCircles[i];
      if (playerNumber != null) {
        circle.paintLayers = playerPaintLayer;
      } else {
        circle.paintLayers = getPlanetPaint(planet.type);
      }
    }
  }

  void phaseUpdate(int playerNumber) {
    if (this.playerNumber != playerNumber) {
      return;
    }

    updateRender();
  }

  bool attackable(int playerNumber) {
    if (neutral()) {
      return false;
    }

    // Maybe add a healthbar for sector?
    return this.playerNumber != playerNumber && false;
  }

  bool neutral() {
    return playerNumber == null;
  }

  void refreshProps() {
    props.clear();

    addProp(SimProps.energy, output);
    addProp(SimProps.production, output);
    addProp(SimProps.civic, output);

    final maintaince = playerNumber == homePlanet ? 0 : 2;
    addProp(SimProps.energy, -maintaince);
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      if (playerNumber != null) "playerNumber": playerNumber,
      "homePlanet": homePlanet,
      "displayName": displayName,
      "hex": hex.toInt(),
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

  static List<Paint> getPlanetPaint(PlanetType t) {
    return switch (t) {
      PlanetType.terran => FlameTheme.planetTerran,
      PlanetType.desert => FlameTheme.planetDesert,
      PlanetType.iron => FlameTheme.planetIron,
      PlanetType.gas => FlameTheme.planetGas,
      PlanetType.ice => FlameTheme.planetIce,
    };
  }
}
