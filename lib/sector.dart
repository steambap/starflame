import 'dart:async';
import 'dart:ui' show Paint, PaintingStyle;
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import "sector_drawing.dart";
import "hex.dart";
import "sim_props.dart";
import 'scifi_game.dart';
import "player_state.dart";
import "planet.dart";
import "styles.dart" show label12, emptyPaint;

class Sector extends PositionComponent
    with HasGameRef<ScifiGame>, ChangeNotifier, SimObject {
  int? playerNumber;
  int team = 0;

  bool homePlanet = false;

  final Hex hex;
  final TextComponent nameLabel = TextComponent(
      text: "",
      position: Vector2(0, 10),
      priority: 1,
      anchor: Anchor.center,
      textRenderer: label12);
  final PolygonComponent ownerHex = PolygonComponent(
      Hex.zero.polygonCorners(Hex.size - 0.5),
      paint: emptyPaint,
      anchor: Anchor.center);
  final List<Orbit> _orbits = [];
  List<Planet> planets;

  Sector(this.hex, {this.planets = const []});

  String _displayName = "";
  String get displayName => _displayName;
  set displayName(String value) {
    _displayName = value;

    String surfix = "I";
    for (final p in planets) {
      if (p.name == "") {
        p.name = "$displayName $surfix";
        surfix += "I";
      }
    }
  }

  @override
  FutureOr<void> onLoad() {
    final List<double> rList = switch (planets.length) {
      1 => const [16],
      2 => const [12, 20],
      _ => const [8, 16, 24],
    };
    for (int i = 0; i < planets.length; i++) {
      final p = planets[i];
      final orbitRadius = rList[i];
      final double planetRadiius = p.workerSlots.length > 1 ? 4 : 3;
      final orbit = Orbit(
          radius: orbitRadius,
          planet: MiniPlanet(radius: planetRadiius, type: p.type),
          revolutionPeriod: orbitRadius * 2,
          initialAngle: orbitRadius + displayName.length);
      _orbits.add(orbit);
    }
    // nameLabel.text = displayName;
    addAll([ownerHex, ..._orbits, nameLabel]);

    refreshProps();
    updateRender();
  }

  void setHome(int playerNumber) {
    this.playerNumber = playerNumber;
    homePlanet = true;
    for (final slot in workerSlots()) {
      if (!slot.isAdvanced) {
        slot.isOccupied = true;
      }
    }
  }

  void colonize(int playerNumber) {
    this.playerNumber = playerNumber;
    updateRender();
  }

  void capture(int playerNumber) {
    this.playerNumber = playerNumber;
    updateRender();
  }

  void updateRender() {
    if (playerNumber == null) {
      ownerHex.paint = emptyPaint;
    } else {
      final pState = game.controller.getPlayerState(playerNumber!);
      final playerPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = pState.color;
      ownerHex.paint = playerPaint;
    }
  }

  void phaseUpdate(int playerNumber) {
    if (this.playerNumber != playerNumber) {
      return;
    }

    updateRender();
  }

  bool attackable(int playerNumber) {
    if (this.playerNumber == null) {
      return false;
    }
    return this.playerNumber != playerNumber;
  }

  bool neutral() {
    return playerNumber == null;
  }

  void refreshProps() {
    props.clear();
    for (final slot in workerSlots()) {
      if (slot.isOccupied) {
        switch (slot.type) {
          case WorkerType.economy:
            addProp(SimProps.credit, WorkerSlot.output);
            break;
          case WorkerType.mining:
            addProp(SimProps.production, WorkerSlot.output);
            break;
          case WorkerType.lab:
            addProp(SimProps.science, WorkerSlot.output);
            break;
        }
      }
    }
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

  bool placeWorker(PlayerState pState, WorkerSlot slot, WorkerType type) {
    final slots = workerSlots();
    if (!slots.contains(slot)) {
      return false;
    }

    if (slot.allowedTypes.contains(type) == false) {
      return false;
    }
    if (slot.isOccupied) {
      return false;
    }
    // if (slot.isAdvanced) {
    //   return false;
    // }

    slot.isOccupied = true;
    slot.type = type;
    refreshProps();
    return true;
  }

  bool switchWorker(PlayerState pState, WorkerSlot slot, WorkerType type) {
    final slots = workerSlots();
    if (!slots.contains(slot)) {
      return false;
    }

    if (slot.allowedTypes.contains(type) == false) {
      return false;
    }
    if (!slot.isOccupied) {
      return false;
    }

    slot.type = type;
    refreshProps();
    if (pState.playerNumber == game.controller.getHumanPlayerNumber()) {
      pState.refreshStatus();
    }
    return true;
  }

  hasOrbital() {
    return planets.any((p) => p.type == PlanetType.orbital);
  }

  addOrbital() {
    planets.add(Planet.orbital());
  }
}
