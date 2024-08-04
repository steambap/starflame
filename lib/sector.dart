import 'dart:async';
import 'dart:ui' show Paint, PaintingStyle;
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import "hex.dart";
import "sim_props.dart";
import 'scifi_game.dart';
import "theme.dart" show text12, emptyPaint;

class Sector extends PositionComponent
    with HasGameRef<ScifiGame>, ChangeNotifier, SimObject {
  int? playerNumber;
  int team = 0;

  bool homePlanet = false;
  String displayName = "";

  final Hex hex;
  final TextComponent nameLabel = TextComponent(
      text: "",
      position: Vector2(60, 0),
      anchor: Anchor.centerRight,
      textRenderer: text12);
  final PolygonComponent ownerHex = PolygonComponent(
      Hex.zero.polygonCorners(Hex.size - 0.5),
      paint: emptyPaint,
      anchor: Anchor.center);
  late final SpriteComponent planetSprite;

  Sector(this.hex);

  @override
  FutureOr<void> onLoad() {
    final img = game.images.fromCache('terran.png');
    final sprite =
        Sprite(img, srcPosition: Vector2.zero(), srcSize: Vector2.all(72));
    planetSprite = SpriteComponent(sprite: sprite, anchor: Anchor.center);

    addAll([ownerHex, planetSprite, nameLabel]);

    refreshProps();
    updateRender();
  }

  void setHome(int playerNumber) {
    this.playerNumber = playerNumber;
    homePlanet = true;
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
    addProp(SimProps.maintainceCost, homePlanet ? 0 : 2);
    addProp(SimProps.production, 5);
    addProp(SimProps.credit, 5);
    addProp(SimProps.science, 5);
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
