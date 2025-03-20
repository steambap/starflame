import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'map_deploy.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';

class HudBottomRight extends StatelessWidget {
  const HudBottomRight(this.game, {super.key});

  static const id = 'hud_bottom_right';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
            )
          ]),
        ));
  }
}
