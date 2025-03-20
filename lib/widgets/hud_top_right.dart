import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'in_game_menu.dart';
import 'research_overlay.dart';
import 'ship_update.dart';
import 'player_info.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';

class HudTopRight extends StatelessWidget {
  const HudTopRight(this.game, {super.key});

  static const id = 'hud_top_right';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 36,
            children: [
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      game.overlays.remove(PlayerInfoBar.id);
                      game.overlays.addAll([ResearchOverlay.id, PlayerInfoBar.id]);
                    },
                    style: AppTheme.primaryButton,
                    icon: const Icon(Symbols.experiment_rounded),
                    label: const Text('Research'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      game.overlays.remove(PlayerInfoBar.id);
                      game.overlays.addAll([ShipUpdate.id, PlayerInfoBar.id]);
                    },
                    style: AppTheme.primaryButton,
                    icon: const Icon(Symbols.branding_watermark_rounded),
                    label: const Text('Ship Design'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      game.overlays.add(InGameMenu.id);
                    },
                    style: AppTheme.primaryButton,
                    icon: const Icon(Symbols.menu_rounded),
                    label: const Text('Menu'),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              Container(
                  transform: Matrix4.translationValues(16, 0, 0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      game.controller.playerEndTurn();
                    },
                    style: AppTheme.primaryButton,
                    icon: const Icon(Symbols.hourglass_bottom_rounded),
                    label: const Text('Next Turn'),
                  ))
            ]),
      ),
    );
  }
}
