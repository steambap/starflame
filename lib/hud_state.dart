import 'package:flutter/material.dart' show ValueNotifier;

import 'planet.dart';

class HudState {
  // Selected planet
  final ValueNotifier<Planet?> planet = ValueNotifier(null);

  void deselectAll() {
    planet.value = null;
  }
}
