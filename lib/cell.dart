import 'dart:async';
import 'package:flame/components.dart';
import 'package:starfury/tile_type.dart';

import 'scifi_game.dart';
import 'hex.dart';
import 'planet.dart';
import 'hex_helper.dart' show cornersOfZero;
import 'tile.dart';
import "planet_type.dart";
import 'ship.dart';
import "theme.dart"
    show hexBorderPaint, highlighterPaint, moveendPaint, targetPaint;

class Cell extends PositionComponent with HasGameRef<ScifiGame> {
  final int index;
  final Hex hex;
  Planet? _planet;
  late final PolygonComponent _hexagon;
  late final PolygonComponent _highligher;
  Tile? _tile;
  Ship? ship;

  Cell(this.index, this.hex) : super(anchor: Anchor.center) {
    position = hex.toPixel();
    _hexagon = PolygonComponent(cornersOfZero,
        anchor: Anchor.center, paint: hexBorderPaint);
    _highligher = PolygonComponent(cornersOfZero,
        anchor: Anchor.center, paint: highlighterPaint);
  }

  @override
  FutureOr<void> onLoad() {
    add(_hexagon);
  }

  Planet setPlanet(PlanetType planetType) {
    _planet?.removeFromParent();
    final newPlanet = Planet(planetType, position: Vector2.zero());
    _planet = newPlanet;
    add(newPlanet);

    return newPlanet;
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

  void unmark() {
    _highligher.removeFromParent();
  }

  FutureOr<void> markAsHighlight([int movePoint = -1]) {
    if (movePoint == 0) {
      _highligher.paint = moveendPaint;
    } else {
      _highligher.paint = highlighterPaint;
    }

    return add(_highligher);
  }

  FutureOr<void> markAsTarget() {
    _highligher.paint = targetPaint;
    return add(_highligher);
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
