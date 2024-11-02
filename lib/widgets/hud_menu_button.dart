import 'package:flutter/material.dart';

import 'in_game_menu.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';

class HudMenuButton extends StatelessWidget {
  const HudMenuButton(this.game, {super.key});

  static const id = 'hud_menu_button';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 8,
        right: 8,
        child: ElevatedButton(
          onPressed: () {
            game.overlays.add(InGameMenu.id);
          },
          style: AppTheme.menuButton,
          child: const Text('MENU'),
        ));
  }
}
