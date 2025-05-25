import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import "hex.dart";
import "sim_props.dart";
import 'scifi_game.dart';
import "player_state.dart";
import "star.dart";
import "styles.dart";

enum PlanetType {
  terran,
  desert,
  iron,
  ice,
  gas,
}

class Planet extends PositionComponent
    with HasGameRef<ScifiGame>, ChangeNotifier, SimObject {
  static const output = 10;

  int? playerNumber;
  int team = 0;

  int homePlanet = -1;

  final Hex hex;
  final PlanetType planetType;
  final StarType starType;
  final TextComponent _nameLabel = TextComponent(
      text: "",
      position: Vector2(0, 24),
      anchor: Anchor.center,
      textRenderer: FlameTheme.text16pale);
  final RectangleComponent _nameBG = RectangleComponent(
      size: Vector2(108, 24),
      position: Vector2(0, 24),
      paintLayers: FlameTheme.labelBackground,
      anchor: Anchor.center);
  late final SpriteComponent _planetSprite;

  Planet(this.hex, this.planetType, this.starType);

  String displayName = "";

  @override
  FutureOr<void> onLoad() {
    _nameLabel.text = displayName;
    final planetImgName = switch (planetType) {
      PlanetType.terran => "terran.png",
      PlanetType.desert => "desert.png",
      PlanetType.ice => "ice.png",
      PlanetType.iron => "iron.png",
      PlanetType.gas => "gas.png",
    };
    final planetImg = game.images.fromCache(planetImgName);
    _planetSprite = SpriteComponent(sprite: Sprite(planetImg), anchor: Anchor.center, scale: Vector2.all(0.5));

    _nameBG.size.x = _nameLabel.size.x + 4;

    addAll([
      _planetSprite,
      _nameBG,
      _nameLabel,
    ]);

    refreshProps();
    updateRender();
  }

  void setHome(PlayerState playerState) {
    playerNumber = playerState.playerNumber;
    homePlanet = playerState.playerNumber;

    refreshProps();
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

    // Maybe add a healthbar?
    return this.playerNumber != playerNumber && false;
  }

  bool neutral() {
    return playerNumber == null;
  }

  void refreshProps() {
    props.clear();

    addProp(SimProps.energy, output);
    addProp(SimProps.production, output);
    addProp(SimProps.politics, output);

    final maintaince = playerNumber == homePlanet ? 0 : 2;
    addProp(SimProps.energy, -maintaince);
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
}
