import 'dart:async';
import 'dart:ui' show Paint, PaintingStyle;
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

// import 'player_state.dart';
import 'building.dart';
import 'scifi_game.dart';
import "hex.dart";
import "planet_type.dart";
import "theme.dart" show text12, emptyPaint;

class Planet extends PositionComponent
    with HasGameRef<ScifiGame>, ChangeNotifier {
  PlanetType type;

  /// 0 = small, 1 = medium, 2 = large
  int planetSize;
  int? playerNumber;
  int citizen = 0;
  int developmentLevel = 0;
  double defense = 0;
  bool isUnderSiege = false;
  final List<Building> buildings = [];
  bool homePlanet = false;
  String displayName = "";

  final Hex hex;
  final Hex sector;
  final TextComponent citizenLabel = TextComponent(
      text: "",
      position: Vector2(0, 36),
      anchor: Anchor.center,
      textRenderer: text12);
  final CircleComponent ownerCircle =
      CircleComponent(radius: 36, paint: emptyPaint, anchor: Anchor.center);
  late final SpriteComponent planetSprite;
  Planet(this.type, this.hex, this.sector, {this.planetSize = 1})
      : super(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    final img = game.images.fromCache(type.image);
    final double xPos = switch (planetSize) {
      0 => 0,
      1 => 72,
      _ => 144,
    };
    final srcPos = Vector2(xPos, 0);
    final sprite = Sprite(img, srcPosition: srcPos, srcSize: Vector2.all(72));
    planetSprite = SpriteComponent(sprite: sprite, anchor: Anchor.center);

    addAll([planetSprite, ownerCircle, citizenLabel]);

    updateRender();
  }

  void setHomePlanet(int playerNumber) {
    this.playerNumber = playerNumber;
    type = PlanetType.terran;
    planetSize = 1;
    homePlanet = true;
    buildings.addAll([
      Building.colonyHQ,
      Building.constructionYard,
    ]);
    citizen = 1;
    defense = defenseMax();
  }

  bool colonize(int progress, int playerNumber) {
    defense += progress;
    if (defense >= defenseMax()) {
      defense = defenseMax();
      this.playerNumber = playerNumber;
      updateRender();

      return true;
    }

    updateRender();

    return false;
  }

  void capture(int playerNumber) {
    // Move all citizens back home before capture
    final state = game.controller.getPlayerState(this.playerNumber!);
    state.citizenInTransport = citizen;
    citizen = 0;

    this.playerNumber = playerNumber;
    updateRender();
  }

  void updateRender() {
    if (playerNumber == null) {
      ownerCircle.paint = emptyPaint;
      citizenLabel.text = "";
    } else {
      citizenLabel.text = "[$citizen]";
      final pState = game.controller.getPlayerState(playerNumber!);
      final playerPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = pState.color;
      ownerCircle.paint = playerPaint;
    }
  }

  void phaseUpdate(int playerNumber) {
    if (this.playerNumber != playerNumber) {
      return;
    }

    if (!isUnderSiege) {
      defense = (defense + 20).clamp(0, defenseMax());
    }

    updateRender();
  }

  bool canRemoveCitizen() {
    return citizen > 0;
  }

  void removeCitizen() {
    citizen--;
    notifyListeners();
  }

  bool canAddCitizen() {
    return citizen < maxCitizen();
  }

  void addCitizen() {
    citizen++;
    notifyListeners();
  }

  bool canUpgrade() {
    return developmentLevel < 2;
  }

  void upgrade() {
    developmentLevel = (developmentLevel + 1).clamp(0, 2);
    updateRender();
    notifyListeners();
  }

  bool canBuild(Building bd) {
    if (bd.uniqueTag.isNotEmpty) {
      for (final b in buildings) {
        if (b.uniqueTag == bd.uniqueTag) {
          return false;
        }
      }
    }
    return buildings.length < maxBuilding();
  }

  void build(Building bd) {
    buildings.add(bd);
    updateRender();
    notifyListeners();
  }

  double defenseMax() {
    return 300 + developmentLevel * 100;
  }

  int maxBuilding() {
    int num = homePlanet ? 1 : 0;
    return planetSize + 2 + num;
  }

  int maxCitizen() {
    return type.maxCitizen + planetSize;
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

  String planetSizeStr() {
    return switch (planetSize) {
      0 => "Small",
      1 => "Medium",
      _ => "Large",
    };
  }
}
