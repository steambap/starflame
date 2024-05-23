// Manage planet state listeners
import 'dart:async';
import 'package:flame/components.dart';

import "planet.dart";
import "hud_planet_info.dart";

class HudPlanet extends PositionComponent {
  final HudPlanetInfo planetInfo = HudPlanetInfo();
  Planet? _planet;
  bool _isScheduled = false;

  HudPlanet();

  Planet? get planet => _planet;

  set planet(Planet? planet) {
    _planet?.removeListener(_scheduleUpdateRender);
    if (planet == null) {
      planetInfo.hide();
    } else {
      planetInfo.show(planet);
      planet.addListener(_scheduleUpdateRender);
    }

    _planet = planet;
  }

  void _scheduleUpdateRender() {
    if (_isScheduled) {
      return;
    }
    _isScheduled = true;

    Future.delayed(const Duration(milliseconds: 100), () {
      _isScheduled = false;
      if (_planet != null) {
        _updateRender();
      }
    });
  }

  void _updateRender() {
    planetInfo.updateRender(_planet!);
  }

  @override
  void onRemove() {
    _planet?.removeListener(_updateRender);
    super.onRemove();
  }

  @override
  Future<void> onLoad() async {
    return add(planetInfo);
  }
}
