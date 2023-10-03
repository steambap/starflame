import 'dart:async';
import 'package:flame/components.dart';

import "planet_type.dart";
import 'scifi_game.dart';

class Planet extends SpriteComponent with HasGameRef<ScifiGame> {
  final PlanetType planetType;
  Planet(this.planetType, {required super.position})
      : super(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    final imgName = switch (planetType) {
      PlanetType.arid => "arid.png",
      PlanetType.ice => "ice.png",
      PlanetType.lava => "lava.png",
      PlanetType.swamp => "swamp.png",
      PlanetType.terran => "terran.png",
    };
    final img = game.images.fromCache(imgName);
    sprite = Sprite(img);
  }
}
