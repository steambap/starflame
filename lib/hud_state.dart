import 'package:flutter/material.dart' show ValueNotifier;

import 'hex.dart';
import 'cell.dart';

class HudState {
  // Selected cell
  final ValueNotifier<Cell> cell = ValueNotifier(Cell(Hex.invalid));
  final ValueNotifier<int> playerInfoVersion = ValueNotifier(-1);

  void deselectCell() {
    cell.value = Cell(Hex.invalid);
  }

  void updatePlayerInfo() {
    playerInfoVersion.value = (playerInfoVersion.value + 1) % 1000;
  }

  void reset() {
    cell.value = Cell(Hex.invalid);
    playerInfoVersion.value = -1;
  }
}
