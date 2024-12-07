import 'dart:async';
import 'dart:ui' show Paint, PaintingStyle;
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
  final ClipComponent _clip = ClipComponent.polygon(
      points: Hex.zero.polygonCorners(Hex.size - 1),
      size: Vector2.all(1),
      priority: 1);
  final TextComponent _nameLabel = TextComponent(
      text: "",
      position: Vector2(0, -18),
      anchor: Anchor.center,
      textRenderer: FlameTheme.text10pale);
  final RectangleComponent _nameBG = RectangleComponent(
      size: Vector2(64, 14),
      position: Vector2(0, -18),
      paintLayers: FlameTheme.labelBackground,
      anchor: Anchor.center);
  final PolygonComponent _ownerHex = PolygonComponent(
      Hex.zero.polygonCorners(Hex.size - 0.5),
      paint: FlameTheme.emptyPaint,
      anchor: Anchor.center);
  final CircleComponent _star = CircleComponent(
      radius: 30, position: Vector2(0, 36), anchor: Anchor.center);

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
    _star.paintLayers = switch (starType) {
      StarType.binary => FlameTheme.binaryPaintLayer,
      StarType.none => FlameTheme.noStarPaintLayer,
      StarType.blue => FlameTheme.blueStarPaintLayer,
      StarType.red => FlameTheme.redStarPaintLayer,
      StarType.yellow => FlameTheme.yellowStarPaintLayer,
      StarType.white => FlameTheme.whiteStarPaintLayer,
    };
    final planetCirclesStart = 3 - (planets.length * 3.0 + (planets.length - 1) * 2);
    for (int i = 0; i < planets.length; i++) {
      final circle = CircleComponent(
          radius: 3,
          position: Vector2(planetCirclesStart + i * 10, -4),
          paintLayers: FlameTheme.planetColonizable,
          anchor: Anchor.center);
      _planetCircles.add(circle);
    }
    _clip.addAll([
      _nameBG,
      _nameLabel,
      _star,
      ..._planetCircles,
    ]);
    addAll([_clip, _ownerHex]);

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
    final pState = playerNumber != null ? game.controller.getPlayerState(playerNumber!) : game.controller.getHumanPlayerState();
    if (playerNumber == null) {
      _ownerHex.paint = FlameTheme.emptyPaint;
    } else {
      final playerPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = pState.color;
      _ownerHex.paint = playerPaint;
    }

    final playerPaintLayer = [
      Paint()
        ..color = pState.color
    ];

    final humanPlayerState = game.controller.getHumanPlayerState();

    for (int i = 0; i < planets.length; i++) {
      final planet = planets[i];
      if (planet.type == PlanetType.orbital) {
        continue;
      }
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

  bool hasOrbital() {
    return planets.any((p) => p.type == PlanetType.orbital);
  }

  void addOrbital() {
    planets.add(Planet.orbital());
    notifyListeners();
  }

  bool canColonizePlanet(Planet planet, PlayerState? pState) {
    final playerState = pState ?? game.controller.getHumanPlayerState();

    return playerState.colonizable.contains(planet.type);
  }
}
