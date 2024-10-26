import 'package:flutter/material.dart' show ValueNotifier;

import 'ship.dart';

class HudState {
  // Selected ship
  final ValueNotifier<Ship?> ship = ValueNotifier(null);
}
