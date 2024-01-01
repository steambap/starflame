import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

import 'building.dart';
import "planet_type.dart";
import "planet_type_helper.dart";
import "planet_state.dart";
import 'scifi_game.dart';
import "theme.dart" show text16, emptyPaint;

class Planet extends PositionComponent with HasGameRef<ScifiGame> {
  late final PlanetState state;
  final TextComponent populationLabel = TextComponent(
      text: "",
      position: Vector2(12, -12),
      anchor: Anchor.center,
      textRenderer: text16);
  final CircleComponent ownerCircle =
      CircleComponent(radius: 16, paint: emptyPaint, anchor: Anchor.center);
  late final SpriteComponent planetSprite;
  Planet(PlanetType planetType, {required super.position})
      : super(anchor: Anchor.center) {
    state = PlanetState(planetType);
  }

  @override
  FutureOr<void> onLoad() {
    final imgName = switch (state.planetType) {
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
    state.playerNumber = playerNumber;
    if (state.population <= 0) {
      state.population = PlanetState.oneM;
    }

    updateRender();
  }

  void setHomePlanet(int playerNumber) {
    state.playerNumber = playerNumber;
    state.population = PlanetState.twoB ~/ 4;
    state.buildings.add(Building.galacticHQ);
  }

  void updateRender() {
    final popLabel = state.popLv() > 0 ? state.popLv().toString() : '';
    populationLabel.text = popLabel;

    if (state.playerNumber == null) {
      ownerCircle.paint = emptyPaint;
    } else {
      final pState = game.controller.getPlayerState(state.playerNumber!);
      final playerPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = pState.color;
      ownerCircle.paint = playerPaint;
    }
  }

  phaseUpdate(int playerNumber) {
    if (state.playerNumber != playerNumber) {
      return;
    }
    if (state.population < PlanetState.twoB) {
      final growthRate = PlanetTypeHelper.growthRateMap[state.planetType] ?? 0;
      state.population +=
          (state.population.toDouble() * (10 + growthRate) / 100).floor();
    }
    state.population = min(state.population, PlanetState.twoB);
    updateRender();
  }

  bool attackable(int playerNumber) {
    if (state.playerNumber == null) {
      return false;
    }
    return state.playerNumber != playerNumber;
  }
}
