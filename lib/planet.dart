import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

// import 'player_state.dart';
import 'scifi_game.dart';
import "hex.dart";
import "planet_type.dart";
import "sim_props.dart";
import "theme.dart" show text12, emptyPaint;

class Planet extends PositionComponent
    with HasGameRef<ScifiGame>, ChangeNotifier, SimObject {
  PlanetType type;

  /// 0 = small, 1 = medium, 2 = large
  int planetSize;
  int? playerNumber;
  int defense = 0;
  bool isUnderSiege = false;
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

    refreshProps();
  }

  void setHomePlanet(int playerNumber) {
    this.playerNumber = playerNumber;
    type = PlanetType.terran;
    planetSize = 1;
    homePlanet = true;

    defense = defenseMax();
  }

  bool colonize(int playerNumber) {
    defense = defenseMax();
    this.playerNumber = playerNumber;

    return false;
  }

  void phaseUpdate(int playerNumber) {
    if (this.playerNumber != playerNumber) {
      return;
    }

    if (!isUnderSiege) {
      defense = (defense + 20).clamp(0, defenseMax());
    }
  }

  int defenseMax() {
    return 100;
  }

  int maxBuilding() {
    int num = homePlanet ? 1 : 0;
    return planetSize + 4 + num;
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

  void refreshProps() {
    props.clear();
    addProp(SimProps.maintainceCost, homePlanet ? 0 : 2);
    addProp(SimProps.production, type.production.toDouble());
    addProp(SimProps.credit, (type.credit + type.food).toDouble());
    addProp(SimProps.science, type.science.toDouble());
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type.name,
      "planetSize": planetSize,
      if (playerNumber != null) "playerNumber": playerNumber,
      "defense": defense,
      "isUnderSiege": isUnderSiege,
      "homePlanet": homePlanet,
      "displayName": displayName,
      "hex": hex.toInt(),
      "sector": sector.toInt(),
    };
  }
}
