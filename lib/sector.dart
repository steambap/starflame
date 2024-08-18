import 'dart:async';
import 'dart:math';
import 'dart:ui' show Paint, PaintingStyle;
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import "hex.dart";
import "sim_props.dart";
import 'scifi_game.dart';
import "player_state.dart";
import "planet.dart";
import "theme.dart" show label12, emptyPaint;

class Sector extends PositionComponent
    with HasGameRef<ScifiGame>, ChangeNotifier, SimObject {
  int? playerNumber;
  int team = 0;

  bool homePlanet = false;
  String displayName = "";

  final Hex hex;
  final TextComponent nameLabel = TextComponent(
      text: "",
      position: Vector2(60, -20),
      anchor: Anchor.centerRight,
      textRenderer: label12);
  final PolygonComponent ownerHex = PolygonComponent(
      Hex.zero.polygonCorners(Hex.size - 0.5),
      paint: emptyPaint,
      anchor: Anchor.center);
  final List<SpriteComponent> planetSprites = [];
  final List<Planet> planets;

  Sector(this.hex, {this.planets = const []});

  @override
  FutureOr<void> onLoad() {
    final economyImage = game.images.fromCache('terran.png');
    final economySprite = Sprite(economyImage,
        srcPosition: Vector2.zero(), srcSize: Vector2.all(72));
    final miningImage = game.images.fromCache('arid.png');
    final miningSprite = Sprite(miningImage,
        srcPosition: Vector2.zero(), srcSize: Vector2.all(72));
    final labImage = game.images.fromCache('ice.png');
    final labSprite =
        Sprite(labImage, srcPosition: Vector2.zero(), srcSize: Vector2.all(72));

    for (int i = 0; i < planets.length; i++) {
      final position = switch (i) {
        1 => Vector2(-Hex.size * 0.25 * sqrt(3.0), Hex.size * 0.25),
        2 => Vector2(Hex.size * 0.25 * sqrt(3.0), Hex.size * 0.25),
        _ => Vector2(0, -Hex.size * 0.5),
      };
      final planet = planets[i];
      final sprite = switch (planet.type) {
        PlanetType.temperate => economySprite,
        PlanetType.hot => miningSprite,
        PlanetType.cold => labSprite,
        _ => economySprite,
      };
      final planetSprite = SpriteComponent(
          sprite: sprite, anchor: Anchor.center, position: position);
      planetSprites.add(planetSprite);
    }

    addAll([ownerHex, ...planetSprites, nameLabel]);

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
      nameLabel.text = "";
      ownerHex.paint = emptyPaint;
    } else {
      nameLabel.text = displayName;
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
    addProp(SimProps.maintainceCost, 1);
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

  bool placeWorker(PlayerState pState, int slotNumber, WorkerType type) {
    final slots = workerSlots();
    if (slotNumber < 0 || slotNumber >= slots.length) {
      return false;
    }
    final slot = slots.elementAt(slotNumber);
    if (slot.allowedTypes.contains(type) == false) {
      return false;
    }
    if (slot.isOccupied) {
      return false;
    }
    if (slot.isAdvanced) {
      return false;
    }

    slot.isOccupied = true;
    slot.type = type;
    refreshProps();
    return true;
  }
}
