import 'dart:async';
import 'package:flame/components.dart';

import 'scifi_game.dart';
import 'hex.dart';
import 'planet.dart';
import 'ship.dart';
import "theme.dart" show highlighterPaint, moveendPaint, targetPaint;
import 'tile_type.dart';

class Cell extends PositionComponent with HasGameRef<ScifiGame> {
  final int index;
  final Hex hex;
  Hex sector = Hex.zero;
  Planet? planet;
  late final PolygonComponent _highligher;
  TileType tileType = TileType.empty;
  Ship? ship;

  Cell(this.index, this.hex) : super(anchor: Anchor.center) {
    position = hex.toPixel();
    _highligher = PolygonComponent(Hex.zero.polygonCorners(),
        anchor: Anchor.center, paint: highlighterPaint);
  }

  @override
  FutureOr<void> onLoad() {
    if (planet != null) {
      add(planet!);
    }
  }

  void unmark() {
    _highligher.removeFromParent();
  }

  FutureOr<void> markAsHighlight([int movePoint = -1]) {
    if (movePoint < TileType.empty.cost) {
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
