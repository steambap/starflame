// Manage planet state listeners
import 'package:flame/components.dart';

import "planet.dart";
import "hud_planet_info.dart";
import "hud_planet_building.dart";

class HudPlanet extends PositionComponent {
  final HudPlanetInfo planetInfo = HudPlanetInfo();
  final HudPlanetBuilding planetBuilding = HudPlanetBuilding();
  Planet? _planet;

  HudPlanet();

  Planet? get planet => _planet;

  set planet(Planet? planet) {
    _planet?.removeListener(_updateRender);
    if (planet == null) {
      planetInfo.hide();
      planetBuilding.hide();
    } else {
      planetInfo.show(planet);
      planetBuilding.show(planet);
      planet.addListener(_updateRender);
    }

    _planet = planet;
  }

  void _updateRender() {
    planetInfo.updateRender(_planet!);
    planetBuilding.updateRender(_planet!);
  }

  @override
  void onRemove() {
    _planet?.removeListener(_updateRender);
    super.onRemove();
  }

  @override
  Future<void> onLoad() async {
    addAll([planetInfo, planetBuilding]);
  }
}