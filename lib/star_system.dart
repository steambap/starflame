import 'dart:async';
import 'dart:math';
import 'dart:ui' show Paint, PaintingStyle;
import 'package:flame/components.dart';

import 'facility.dart';
import "planet.dart";
import 'scifi_game.dart';
import "hex.dart";
import "theme.dart" show text12, emptyPaint;

class StarSystem extends PositionComponent with HasGameRef<ScifiGame> {
  int? playerNumber;
  int population = 0;
  double growth = 0;
  double energy = 0;
  double metal = 0;
  double defense = 0;
  bool isUnderSiege = false;
  late final List<Planet> planets;
  final List<Facility> facilities = [];
  bool homePlanet = false;
  String displayName = "";

  final Hex hex;
  final TextComponent populationLabel = TextComponent(
      text: "",
      position: Vector2(0, 36),
      anchor: Anchor.center,
      textRenderer: text12);
  final CircleComponent ownerCircle =
      CircleComponent(radius: 34, paint: emptyPaint, anchor: Anchor.center);
  late final SpriteComponent planetSprite;
  StarSystem(this.planets, this.hex) : super(anchor: Anchor.center) {
    assert(planets.isNotEmpty);
  }

  @override
  FutureOr<void> onLoad() {
    final img = game.images.fromCache(planets[0].type.image);
    final sprite = Sprite(img);
    planetSprite = SpriteComponent(sprite: sprite, anchor: Anchor.center);

    addAll([planetSprite, ownerCircle, populationLabel]);

    updateRender();
  }

  void setHomePlanet(int playerNumber) {
    this.playerNumber = playerNumber;
    homePlanet = true;
    planets[0].setHome();
    population = 5;
    facilities.addAll([
      Facility(FacilityType.medicalLab),
      Facility(FacilityType.fusionReactor),
      Facility(FacilityType.metalExtractor)
    ]);
    energy = energyMax() / 2;
    metal = metalMax() / 2;
  }

  void colonize(int playerNumber, int population) {
    this.playerNumber = playerNumber;
    this.population = population;
    updateRender();
    game.playerInfo.updateRender();
  }

  void capture(int playerNumber) {
    this.playerNumber = playerNumber;
    population ~/= 2;
    updateRender();
    game.playerInfo.updateRender();
  }

  void updateRender() {
    final popLabel = population > 0 ? population.toString() : '';

    if (playerNumber == null) {
      ownerCircle.paint = emptyPaint;
      populationLabel.text = "";
    } else {
      populationLabel.text = "[$popLabel]$displayName";
      final pState = game.controller.getPlayerState(playerNumber!);
      final playerPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = pState.color;
      ownerCircle.paint = playerPaint;
    }
  }

  int maxPop() {
    int sum = 0;
    for (final planet in planets) {
      if (planet.colonized) {
        sum += planet.type.maxPopulation + planet.size;
      }
    }

    return sum;
  }

  int approval() {
    int sum = 50;
    for (final planet in planets) {
      if (planet.colonized) {
        sum += planet.type.approval;
      }
    }

    sum -= population;

    return min(sum, 0);
  }

  int food() {
    int sum = 0;
    for (final planet in planets) {
      if (planet.colonized) {
        sum += planet.type.growth;
      }
    }
    for (final f in facilities) {
      if (f.type == FacilityType.medicalLab) {
        sum += 15;
      }
    }

    return sum;
  }

  phaseUpdate(int playerNumber) {
    if (this.playerNumber != playerNumber) {
      return;
    }
    _popUpdate();
    _popWork();

    updateRender();
  }

  void _popUpdate() {
    if (population >= maxPop()) {
      return;
    }
    growth += food() * (1.0 + (approval() / 100));
    if (growth >= 100) {
      population++;
      growth -= 100;
    }
  }

  void _popWork() {
    if (energy >= energyMax() && metal >= metalMax()) {
      return;
    }
    final double mod = 1.0 + (approval() / 100);

    if (energy >= energyMax()) {
      metal += population * 6 * mod;
    } else if (metal >= metalMax()) {
      energy += population * 6 * mod;
    } else {
      energy += population * 3 * mod;
      metal += population * 3 * mod;
    }

    energy = energy.clamp(0, energyMax());
    metal = metal.clamp(0, metalMax());
  }

  double energyMax() {
    double sum = 0;
    for (final planet in planets) {
      if (planet.colonized) {
        sum += planet.type.energy * 75;
      }
    }
    for (final f in facilities) {
      if (f.type == FacilityType.fusionReactor) {
        sum += 350;
      }
    }

    return sum;
  }

  double metalMax() {
    double sum = 0;
    for (final planet in planets) {
      if (planet.colonized) {
        sum += planet.type.metal * 75;
      }
    }
    for (final f in facilities) {
      if (f.type == FacilityType.metalExtractor) {
        sum += 350;
      }
    }

    return sum;
  }

  double energyIncome() {
    return energy * 1.0;
  }

  double metalIncome() {
    return metal * 0.1;
  }

  bool canBuild() {
    return population - 2 * facilities.length > 0;
  }

  void production(int playerNumber) {
    produceEnergy(playerNumber);
    produceMetal(playerNumber);
  }

  void produceEnergy(int playerNumber) {
    final playerState = game.controller.getPlayerState(playerNumber);
    final energy = energyIncome();
    playerState.energy += energy;
  }

  void produceMetal(int playerNumber) {
    final playerState = game.controller.getPlayerState(playerNumber);
    final metal = metalIncome();
    playerState.metal += metal;
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
}
