import 'package:flutter/material.dart' show ValueNotifier;

import 'ship.dart';
import 'sector.dart';

class HudState {
  // Selected ship
  final ValueNotifier<Ship?> ship = ValueNotifier(null);
  // Selected sector
  final ValueNotifier<Sector?> sector = ValueNotifier(null);

  /// Useful when the user go to the main menu
  void deselectAll() {
    ship.value = null;
    sector.value = null;
  }
}
