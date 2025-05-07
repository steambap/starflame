import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'in_game_menu.dart';
import 'map_deploy.dart';
import 'research_overlay.dart';
import 'ship_update.dart';
import 'player_info.dart';
import 'trade_overlay.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';

class HudTopLeft extends StatelessWidget {
  const HudTopLeft(this.game, {super.key});

  static const id = 'hud_top_left';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Container(
            transform: Matrix4.translationValues(-24, -12, 0),
            width: 48,
            height: 288,
            decoration: const ShapeDecoration(
              color: AppTheme.panelBackground,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(12),
                ),
                side: BorderSide(
                  color: AppTheme.panelBorder,
                ),
              ),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                IconButton(
                  onPressed: () {
                    game.overlays.add(InGameMenu.id);
                  },
                  style: AppTheme.iconButton,
                  icon: const Icon(Symbols.menu_rounded),
                ),
                IconButton(
                  onPressed: () {
                    game.overlays.remove(PlayerInfoBar.id);
                    game.overlays.addAll([ShipUpdate.id, PlayerInfoBar.id]);
                  },
                  style: AppTheme.iconButton,
                  icon: const Icon(Symbols.branding_watermark_rounded),
                ),
                IconButton(
                  onPressed: () {
                    game.overlays.remove(PlayerInfoBar.id);
                    game.overlays
                        .addAll([ResearchOverlay.id, PlayerInfoBar.id]);
                  },
                  style: AppTheme.iconButton,
                  icon: const Icon(Symbols.experiment_rounded),
                ),
                IconButton(
                  onPressed: () {
                    if (game.overlays.isActive(MapDeploy.id)) {
                      game.overlays.remove(MapDeploy.id);
                    } else {
                      game.overlays.add(MapDeploy.id);
                    }
                  },
                  style: AppTheme.iconButton,
                  icon: const Icon(Symbols.build_rounded),
                ),
                IconButton(
                  onPressed: () {
                    game.overlays.remove(PlayerInfoBar.id);
                    game.overlays.addAll([TradeOverlay.id, PlayerInfoBar.id]);
                  },
                  style: AppTheme.iconButton,
                  icon: const Icon(Symbols.balance_rounded),
                ),
              ]),
        ],
      ),
    );
  }
}
