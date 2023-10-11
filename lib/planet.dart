import 'dart:async';
import 'package:flame/components.dart';

import "planet_type.dart";
import "planet_state.dart";
import 'scifi_game.dart';

class Planet extends SpriteComponent with HasGameRef<ScifiGame> {
  late final PlanetState planetState;
  final TextComponent populationLabel = TextComponent(text: "", position: Vector2(-2, 0), anchor: Anchor.center);
  Planet(PlanetType planetType, {required super.position})
      : super(anchor: Anchor.center) {
    planetState = PlanetState(planetType);
  }

  @override
  FutureOr<void> onLoad() {
    final imgName = switch (planetState.planetType) {
      PlanetType.arid => "arid.png",
      PlanetType.ice => "ice.png",
      PlanetType.lava => "lava.png",
      PlanetType.swamp => "swamp.png",
      PlanetType.terran => "terran.png",
    };
    final img = game.images.fromCache(imgName);
    sprite = Sprite(img);

    add(populationLabel);
  }

  colonize(int playerNumber) {
    planetState.playerNumber = playerNumber;
    if (planetState.population <= 0) {
      planetState.population = 1;
    }
  }
}
