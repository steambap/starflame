import 'package:flutter/material.dart' show ValueNotifier;

import 'ship.dart';
import 'planet.dart';

class HudState {
  // Selected ship
  final ValueNotifier<Ship?> ship = ValueNotifier(null);
  // Selected planet
  final ValueNotifier<Planet?> planet = ValueNotifier(null);

  /// Useful when the user go to the main menu
  void deselectAll() {
    ship.value = null;
    planet.value = null;
  }
}
