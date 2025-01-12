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
      position: Vector2(0, 16),
      anchor: Anchor.center,
      textRenderer: FlameTheme.text10pale);
  final RectangleComponent _nameBG = RectangleComponent(
      size: Vector2(64, 14),
      position: Vector2(0, 16),
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
    for (final planet in planets) {
      if (canColonizePlanet(planet, playerState)) {
        for (final slot in planet.workerSlots) {
          slot.isOccupied = true;
        }
      }
    }
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

    for (int i = 0; i < planets.length; i++) {
      final planet = planets[i];
      final circle = _planetCircles[i];
      if (planet.hasWorker()) {
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
    for (final p in planets) {
      for (final slot in p.workerSlots) {
        if (slot.isOccupied) {
          addProp(slot.type.output, output);
        }
      }
    }
    final supportOutput = playerNumber == homePlanet ? 6 : -1;
    addProp(SimProps.support, supportOutput);
    final maintaince = playerNumber == homePlanet ? 0 : 2;
    addProp(SimProps.credit, -maintaince);
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

  Iterable<WorkerSlot> workerSlots() {
    return planets.expand((p) => p.workerSlots);
  }

  bool placeWorker(PlayerState pState, Planet planet, WorkerType type) {
    final slot = planet.workerSlots.firstWhere((s) => s.type == type);

    if (slot.isOccupied) {
      return false;
    }

    slot.isOccupied = true;
    refreshProps();
    return true;
  }

  bool canColonizePlanet(Planet planet, PlayerState? pState) {
    final playerState = pState ?? game.controller.getHumanPlayerState();

    return playerState.colonizable.contains(planet.type);
  }
}
