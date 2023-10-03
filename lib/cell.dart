import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:starfury/tile_type.dart';

import 'scifi_game.dart';
import 'hex.dart';
import 'planet.dart';
import 'hex_helper.dart' show cornersOfZero;
import 'tile.dart';
import "planet_type.dart";

class Cell extends PositionComponent with HasGameRef<ScifiGame> {
  final Hex hex;
  Planet? _planet;
  late final PolygonComponent _hexagon;
  Tile? _tile;

  Cell(this.hex) : super(anchor: Anchor.center) {
    position = hex.toPixel();
    final hexPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey;
    _hexagon =
        PolygonComponent(cornersOfZero, anchor: Anchor.center, paint: hexPaint);
  }

  @override
  FutureOr<void> onLoad() {
    add(_hexagon);
  }

  setPlanet(PlanetType planetType) {
    _planet?.removeFromParent();
    final newPlanet = Planet(planetType, position: Vector2.zero());
    _planet = newPlanet;
    add(newPlanet);
  }

  Planet? get planet => _planet;

  set tileType(TileType t) {
    _tile?.removeFromParent();
    if (t == TileType.empty) {
      return;
    }

    final newTile = Tile(t);
    _tile = newTile;
    add(newTile);
  }

  TileType get tileType => _tile?.tileType ?? TileType.empty;
}
