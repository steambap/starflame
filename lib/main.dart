import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import './scifi_game.dart';

void main() {
  runApp(const GameWidget.controlled(gameFactory: ScifiGame.new));
}
