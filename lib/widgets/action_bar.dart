import 'package:flutter/material.dart';

import 'map_deploy.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/research_overlay.dart';
import 'package:starflame/data/lucide_icon.dart';

class ActionBar extends StatelessWidget {
  const ActionBar(this.game, {super.key});

  static const id = 'action_bar';
  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppTheme.navbarHeight + 4, horizontal: 4),
      child: Row(
        children: [
          IconButton.outlined(
            onPressed: () {
              if (game.overlays.isActive(MapDeploy.id)) {
                game.overlays.remove(MapDeploy.id);
              } else {
                game.overlays.add(MapDeploy.id);
              }
            },
            icon: LucideIcon.wrench,
            style: AppTheme.iconButton,
          ),
          const SizedBox(width: 4),
          IconButton.outlined(
            onPressed: () {
              game.router.pushRoute(ResearchOverlay());
            },
            icon: LucideIcon.flaskRoundBottom,
            style: AppTheme.iconButton,
          ),
          const SizedBox(width: 4),
          IconButton.outlined(
            onPressed: null,
            icon: LucideIcon.combine,
            style: AppTheme.iconButton,
          ),
        ],
      ),
    );
  }
}
