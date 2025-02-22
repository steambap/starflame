import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'map_deploy.dart';
import 'research_overlay.dart';
import 'player_info.dart';
import 'ship_update.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';

class ActionBar extends StatelessWidget {
  const ActionBar(this.game, {super.key});

  static const id = 'action_bar';
  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppTheme.navbarMargin, horizontal: 4),
      child: Row(
        spacing: 4,
        children: [
          IconButton.outlined(
            onPressed: () {
              if (game.overlays.isActive(MapDeploy.id)) {
                game.overlays.remove(MapDeploy.id);
              } else {
                game.overlays.add(MapDeploy.id);
              }
            },
            icon: const Icon(Symbols.build_rounded),
            style: AppTheme.iconButton,
          ),
          IconButton.outlined(
            onPressed: () {
              game.overlays.remove(PlayerInfoBar.id);
              game.overlays.addAll([ResearchOverlay.id, PlayerInfoBar.id]);
            },
            icon: const Icon(Symbols.experiment_rounded),
            style: AppTheme.iconButton,
          ),
          IconButton.outlined(
            onPressed: () {
              game.overlays.remove(PlayerInfoBar.id);
              game.overlays.addAll([ShipUpdate.id, PlayerInfoBar.id]);
            },
            icon: const Icon(Symbols.combine_columns_rounded),
            style: AppTheme.iconButton,
          ),
        ],
      ),
    );
  }
}
