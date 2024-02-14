import 'dart:async';
import 'dart:math';
import 'dart:ui' show Paint, PaintingStyle;
import 'package:flame/components.dart';

import 'building.dart';
import "planet_type.dart";
import "planet_state.dart";
import 'scifi_game.dart';
import "theme.dart" show text16, emptyPaint;

class Planet extends PositionComponent with HasGameRef<ScifiGame> {
  late final PlanetState state;
  final TextComponent populationLabel = TextComponent(
      text: "",
      position: Vector2(-12, 36),
      anchor: Anchor.center,
      textRenderer: text16);
  final CircleComponent ownerCircle =
      CircleComponent(radius: 34, paint: emptyPaint, anchor: Anchor.center);
  late final SpriteComponent planetSprite;
  Planet(PlanetType planetType, {required super.position})
      : super(anchor: Anchor.center) {
    state = PlanetState(planetType);
  }

  @override
  FutureOr<void> onLoad() {
    final img = game.images.fromCache(state.planetType.image);
    final sprite = Sprite(img);
    planetSprite = SpriteComponent(sprite: sprite, anchor: Anchor.center);

    addAll([planetSprite, ownerCircle, populationLabel]);

    updateRender();
  }

  void setHomePlanet(int playerNumber) {
    state.playerNumber = playerNumber;
    state.size = PlanetSize.medium;
    state.population = state.size.maxPopulation;
    state.buildings.addAll([Building.galacticHQ, Building.shipyard]);
  }

  void colonize(int playerNumber, int population) {
    state.playerNumber = playerNumber;
    state.population = population;
    updateRender();
    game.playerInfo.updateRender();
  }

  void capture(int playerNumber) {
    state.playerNumber = playerNumber;
    state.population ~/= 2;
    updateRender();
    game.playerInfo.updateRender();
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
    if (state.population < state.size.maxPopulation) {
      final growthRate = state.planetType.growthRate;
      state.population +=
          (state.population.toDouble() * (10 + growthRate) / 100).floor();
    }
    state.population = min(state.population, state.size.maxPopulation);
    updateRender();
  }

  double energyIncome() {
    double energyMultiplier = state.planetType.energy.toDouble();
    for (final element in state.buildings) {
      if (element == Building.galacticHQ) {
        energyMultiplier += 5;
      }
    }

    return state.popLv() * energyMultiplier;
  }

  void produceEnergy(int playerNumber) {
    final playerState = game.controller.getPlayerState(playerNumber);
    final energy = energyIncome();
    playerState.energy += energy;
  }

  bool attackable(int playerNumber) {
    if (state.playerNumber == null) {
      return false;
    }
    return state.playerNumber != playerNumber;
  }

  bool neutral() {
    return state.playerNumber == null;
  }
}
