import 'package:flame/components.dart';

import 'planet.dart';
import 'scifi_game.dart';
import 'hud_state.dart';
import 'map_grid.dart';

class SelectControlComponent extends Component
    with HasGameReference<ScifiGame>, ParentIsA<MapGrid> {
  void onPlanetClick(Planet planet) {}
}

class SelectControlWaitForInput extends SelectControlComponent {
  @override
  void onPlanetClick(Planet planet) {
    game.mapGrid.selectControl = SelectControlPlanet(planet);
  }
}

class SelectControlPlanet extends SelectControlComponent {
  final Planet planet;

  SelectControlPlanet(this.planet);

  @override
  void onMount() {
    game.getIt<HudState>().planet.value = planet;
    planet.select();
    planet.priority = 2;

    super.onMount();
  }

  @override
  void onRemove() {
    game.getIt<HudState>().planet.value = null;
    planet.deselect();
    planet.priority = -1;
  }

  @override
  void onPlanetClick(Planet planet) {
    if (this.planet == planet) {
      this.planet.rallyPoint = null;
      return;
    }
    if (game.mapGrid.isPlanetConnected(this.planet, planet) && !this.planet.isNeutral()) {
      this.planet.rallyPoint = planet;
      return;
    }

    game.mapGrid.selectControl = SelectControlPlanet(planet);
  }
}
