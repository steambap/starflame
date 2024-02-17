import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:starfury/tile_type.dart';

import 'scifi_game.dart';
import 'hex.dart';
import 'star_system.dart';
import 'tile.dart';
import 'ship.dart';
import "theme.dart" show highlighterPaint, moveendPaint, targetPaint, text12;

class Cell extends PositionComponent with HasGameRef<ScifiGame> {
  final int index;
  final Hex hex;
  Hex sector = Hex.zero;
  StarSystem? system;
  late final PolygonComponent _highligher;
  Tile? _tile;
  Ship? ship;

  Cell(this.index, this.hex) : super(anchor: Anchor.center) {
    position = hex.toPixel();
    _highligher = PolygonComponent(Hex.zero.polygonCorners(),
        anchor: Anchor.center, paint: highlighterPaint);
  }

  @override
  FutureOr<void> onLoad() {
    if (system != null) {
      add(system!);
    }
  }

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
    return "Cell$hex,${tileType.name}";
  }
}
