import 'dart:async';
import 'dart:ui' show Paint;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'scifi_game.dart';
import 'hex.dart';
import 'planet.dart';
import 'ship.dart';
import "styles.dart";
import 'tile_type.dart';

class Cell extends PositionComponent with HasGameReference<ScifiGame> {
  final int index;
  final Hex hex;
  Planet? planet;
  late final PolygonComponent _highligher;
  late final PolygonComponent _fog;
  TileType tileType = TileType.empty;
  SpriteComponent? tileSprite;
  Ship? ship;

  Cell(this.index, this.hex) : super(anchor: Anchor.center) {
    position = hex.toPixel();
    _highligher = PolygonComponent(Hex.zero.polygonCorners(),
        anchor: Anchor.center, paint: FlameTheme.highlighterPaint, priority: 2);
    _fog = PolygonComponent(Hex.zero.polygonCorners(Hex.size - 0.5),
        position: position,
        anchor: Anchor.center,
        paint: Paint.from(FlameTheme.fogPaint));
  }

  @override
  FutureOr<void> onLoad() {
    Sprite? sprite;
    if (tileType == TileType.gravityRift) {
      sprite = Sprite(game.images.fromCache("gravity_rift.png"));
    } else if (tileType == TileType.nebula) {
      sprite = Sprite(game.images.fromCache("nebula.png"));
    } else if (tileType == TileType.asteroidField) {
      sprite = Sprite(game.images.fromCache("asteroid.png"));
    }

    if (sprite != null) {
      tileSprite = SpriteComponent(sprite: sprite, anchor: Anchor.center);
      add(tileSprite!);
    }
    if (planet != null) {
      add(planet!);
    }

    // showFog();
  }

  void showFog() {
    game.mapGrid.fogLayer.add(_fog);
  }

  void hideFog() {
    _fog.removeFromParent();
  }

  /// Hide fog with animation
  void reveal() {
    if (_fog.parent == null) {
      return;
    }

    _fog.add(OpacityEffect.fadeOut(EffectController(duration: 0.75)));
  }

  void unmark() {
    _highligher.removeFromParent();
  }

  FutureOr<void> markAsHighlight() {
    _highligher.paint = FlameTheme.highlighterPaint;

    return add(_highligher);
  }

  FutureOr<void> markAsTarget() {
    _highligher.paint = FlameTheme.targetPaint;
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

  Map<String, dynamic> toJson() {
    return {
      "index": index,
      "hex": hex.toInt(),
      "tileType": tileType.name,
      // sectors and ships are saved under map grid
    };
  }
}
