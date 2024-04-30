import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';

import 'scifi_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  
  runApp(GameWidget(game: ScifiGame()));
}
