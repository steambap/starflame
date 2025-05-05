import 'dart:async';
import 'dart:math';
import 'dart:ui' show Paint;
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'resource.dart';
import "hex.dart";
import "sim_props.dart";
import 'scifi_game.dart';
import "player_state.dart";
import "planet.dart";
import "star.dart";
import "styles.dart";

class SectorOutput {
  int credit;
  int science;
  int production;

  SectorOutput({this.credit = 0, this.science = 0, this.production = 0});

  int of(String prop) {
    return switch (prop) {
      SimProps.credit => credit,
      SimProps.science => science,
      SimProps.production => production,
      _ => 0,
    };
  }
}

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

  final currentOutput = SectorOutput();
  final maxOutput = SectorOutput();

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
        p.name = "$displayName $surfix";
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
        3 - (planets.length * 3.0 + (planets.length - 1) * 2);
    for (int i = 0; i < planets.length; i++) {
      final circle = CircleComponent(
          radius: 3,
          position: Vector2(planetCirclesStart + i * 10, -16),
          paintLayers: FlameTheme.planetColonizable,
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

    updateMaxOutput();
    fillOutput();
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

    final humanPlayerState = game.controller.getHumanPlayerState();

    for (int i = 0; i < _planetCircles.length; i++) {
      final planet = planets[i];
      final circle = _planetCircles[i];
      if (planet.isColonized) {
        circle.paintLayers = playerPaintLayer;
      } else {
        if (humanPlayerState.colonizable.contains(planet.type)) {
          circle.paintLayers = FlameTheme.planetColonizable;
        } else {
          circle.paintLayers = FlameTheme.planetUncolonizable;
        }
      }
    }
  }

  void updateMaxOutput() {
    Resources r = const Resources();
    for (final planet in planets) {
      if (planet.isColonized) {
        r += Planet.getPlanetProps(planet.type);
      }
    }

    maxOutput.credit = r.credit;
    maxOutput.science = r.science;
    maxOutput.production = r.production;

    refreshProps();
  }

  void fillOutput() {
    currentOutput.credit = maxOutput.credit;
    currentOutput.science = maxOutput.science;
    currentOutput.production = maxOutput.production;
  }

  bool canIncreaseOutput(String prop) {
    if (prop == SimProps.credit) {
      return currentOutput.credit < maxOutput.credit;
    } else if (prop == SimProps.science) {
      return currentOutput.science < maxOutput.science;
    } else if (prop == SimProps.production) {
      return currentOutput.production < maxOutput.production;
    } else {
      return false;
    }
  }

  int predictIncreaseOutput(String prop) {
    if (!canIncreaseOutput(prop)) {
      return 0;
    }

    if (prop == SimProps.credit) {
      return min(maxOutput.credit - currentOutput.credit, 2);
    } else if (prop == SimProps.science) {
      return min(maxOutput.science - currentOutput.science, 2);
    } else if (prop == SimProps.production) {
      return min(maxOutput.production - currentOutput.production, 2);
    } else {
      return 0;
    }
  }

  bool increaseOutput(String prop) {
    if (prop == SimProps.credit) {
      currentOutput.credit += predictIncreaseOutput(prop);
    } else if (prop == SimProps.science) {
      currentOutput.science += predictIncreaseOutput(prop);
    } else if (prop == SimProps.production) {
      currentOutput.production += predictIncreaseOutput(prop);
    } else {
      return false;
    }

    refreshProps();

    return true;
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
    return this.playerNumber != playerNumber;
  }

  bool neutral() {
    return playerNumber == null;
  }

  void refreshProps() {
    props.clear();

    addProp(SimProps.credit, currentOutput.credit);
    addProp(SimProps.science, currentOutput.science);
    addProp(SimProps.production, currentOutput.production);

    final supportOutput = playerNumber == homePlanet ? 6 : -1;
    addProp(SimProps.support, supportOutput);
    final maintaince = playerNumber == homePlanet ? 0 : 2;
    addProp(SimProps.credit, -maintaince);
    notifyListeners();
  }

  bool canColonizePlanet(Planet planet, PlayerState? pState) {
    final playerState = pState ?? game.controller.getHumanPlayerState();

    return playerState.colonizable.contains(planet.type);
  }

  bool colonizePlanet(Planet planet, PlayerState? pState) {
    final playerState = pState ?? game.controller.getHumanPlayerState();

    if (!canColonizePlanet(planet, playerState)) {
      return false;
    }

    if (planet.isColonized) {
      return false;
    }

    planet.isColonized = true;
    updateMaxOutput();

    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      if (playerNumber != null) "playerNumber": playerNumber,
      "homePlanet": homePlanet,
      "displayName": displayName,
      "hex": hex.toInt(),
    };
  }
}
