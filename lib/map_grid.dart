import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'scifi_game.dart';
import 'planet.dart';
import 'ship.dart';
import 'select_control.dart';

final testPlanets = [
  Vector2(-100, 100),
  Vector2(200, 150),
  Vector2(300, -200),
];

class MapGrid extends Component
    with HasGameReference<ScifiGame>, TapCallbacks, HasCollisionDetection {
  final List<Planet> planets = [];
  final List<Ship> ships = [];
  late SelectControlComponent _selectControl;

  set selectControl(SelectControlComponent s) {
    _selectControl.removeFromParent();
    _selectControl = s;
    add(_selectControl);
  }

  SelectControlComponent get selectControl => _selectControl;

  void deselect() {
    selectControl = SelectControlWaitForInput();
  }

  void start() {
    for (int i = 0; i < testPlanets.length; i++) {
      final pos = testPlanets[i];
      final planet = Planet(i, PlanetType.values[i], position: pos);
      planets.add(planet);
      add(planet);
    }
  }

  void addShip(Ship ship) {
    ships.add(ship);
    add(ship);
  }

  @override
  FutureOr<void> onLoad() {
    _selectControl = SelectControlWaitForInput();
    add(_selectControl);

    return super.onLoad();
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    bool found = false;
    for (final planet in planets) {
      if (planet.position.distanceTo(event.localPosition) <= Planet.radius) {
        selectControl.onPlanetClick(planet);
        found = true;
        break;
      }
    }

    if (!found) {
      selectControl = SelectControlWaitForInput();
    }

    super.onTapUp(event);
  }
}
