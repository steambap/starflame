import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:starfury/tile_type.dart';

import 'scifi_game.dart';
import 'hex.dart';
import 'planet.dart';
import 'hex_helper.dart' show cornersOfZero;
import 'tile.dart';
import "planet_type.dart";
import "fleet.dart";

class Cell extends PositionComponent with HasGameRef<ScifiGame> {
  final Hex hex;
  Planet? _planet;
  late final PolygonComponent _hexagon;
  late final PolygonComponent _highligher;
  Tile? _tile;
  List<Fleet> fleets = List.empty(growable: true);

  Cell(this.hex) : super(anchor: Anchor.center) {
    position = hex.toPixel();
    final hexPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color.fromARGB(255, 128, 128, 128);
    _hexagon =
        PolygonComponent(cornersOfZero, anchor: Anchor.center, paint: hexPaint);

    final highlighterPaint = Paint()
      ..color = const Color.fromARGB(128, 20, 60, 236);
    _highligher = PolygonComponent(cornersOfZero,
        anchor: Anchor.center, paint: highlighterPaint);
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

  unmark() {
    _highligher.removeFromParent();
  }

  markAsHighlight() {
    add(_highligher);
  }

  @override
  int get hashCode => hex.hashCode;

  @override
  bool operator ==(Object other) {
    return (other is Cell) && hex == other.hex;
  }

  @override
  String toString() {
    return "Cell$hex,$tileType";
  }
}
