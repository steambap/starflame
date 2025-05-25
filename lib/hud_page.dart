import 'dart:async';
import 'package:flame/components.dart';

import 'scifi_game.dart';

class HudPage extends Component with HasGameRef<ScifiGame> {
  static const routeName = 'hud';

  HudPage({super.children, super.priority, super.key});

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    if (!game.controller.isGameStarted) {
      game.startTestGame();
    }
  }
}
