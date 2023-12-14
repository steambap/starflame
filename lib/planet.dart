import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;

import 'building.dart';
import "planet_type.dart";
import "planet_state.dart";
import 'scifi_game.dart';

class Planet extends PositionComponent with HasGameRef<ScifiGame> {
  static final emptyPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.transparent;

  late final PlanetState planetState;
  final TextComponent populationLabel = TextComponent(
      text: "", position: Vector2.all(-12), anchor: Anchor.center);
  final CircleComponent ownerCircle =
      CircleComponent(radius: 16, paint: emptyPaint, anchor: Anchor.center);
  late final SpriteComponent planetSprite;
  Planet(PlanetType planetType, {required super.position})
      : super(anchor: Anchor.center) {
    planetState = PlanetState(planetType);
  }

  @override
  FutureOr<void> onLoad() {
    final imgName = switch (planetState.planetType) {
      PlanetType.arid => "arid.png",
      PlanetType.ice => "ice.png",
      PlanetType.lava => "lava.png",
      PlanetType.swamp => "swamp.png",
      PlanetType.terran => "terran.png",
    };
    final img = game.images.fromCache(imgName);
    final sprite = Sprite(img);
    planetSprite = SpriteComponent(sprite: sprite, anchor: Anchor.center);

    addAll([planetSprite, ownerCircle, populationLabel]);

    updateRender();
  }

  colonize(int playerNumber) {
    planetState.playerNumber = playerNumber;
    if (planetState.population <= 0) {
      planetState.population = 1;
    }

    updateRender();
  }

  setHomePlanet(int playerNumber) {
    planetState.playerNumber = playerNumber;
    planetState.population = 6;
    planetState.buildings.add(Building.galacticHQ);
  }

  void updateRender() {
    final popLabel =
        planetState.population > 0 ? planetState.population.toString() : '';
    populationLabel.text = popLabel;

    if (planetState.playerNumber == null) {
      ownerCircle.paint = emptyPaint;
    } else {
      final pState =
          game.gameStateController.getPlayerState(planetState.playerNumber!);
      final playerPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = pState.color;
      ownerCircle.paint = playerPaint;
    }
  }
}
