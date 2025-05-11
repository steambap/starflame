import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:starflame/ship_blueprint.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/player_state.dart';
import 'package:starflame/select_control.dart';

class MapDeploy extends StatelessWidget with WatchItMixin {
  const MapDeploy(this.game, {super.key});

  static const id = 'map_deploy';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    final playerState =
        watch<PlayerState>(game.controller.getHumanPlayerState());

    return Container(
        margin: const EdgeInsets.all(8),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              for (final hull in playerState.blueprints
                  .where((bp) => bp.active && bp.buildable))
                _addShipButton(playerState, hull)
            ],
          ),
        ));
  }

  Widget _addShipButton(PlayerState playerState, ShipBlueprint hull) {
    final isEnabled = game.resourceController
        .canCreateShip(game.controller.getHumanPlayerState(), hull)
        .ok;
    final textStyle = isEnabled ? AppTheme.label12 : AppTheme.label12Gray;

    return SizedBox(
        width: 120,
        height: 84,
        child: Material(
          color: isEnabled
              ? AppTheme.addShipButtonColor
              : AppTheme.addShipButtonDisabledColor,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: AppTheme.addShipButtonBorder),
          ),
          child: InkWell(
              hoverColor: AppTheme.addShipButtonHoverColor,
              onTap: isEnabled
                  ? () {
                      game.mapGrid.selectControl =
                          SelectControlCreateShip(game, hull);
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hull.className, style: textStyle),
                    Expanded(
                        child: Center(
                      child: SizedBox(
                        width: 72,
                        height: 72,
                        child: SpriteWidget(
                          sprite: Sprite(game.images.fromCache(hull.image),
                              srcSize: Vector2.all(144)),
                          anchor: Anchor.center,
                        ),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: RichText(
                          text: TextSpan(style: textStyle, children: [
                        const WidgetSpan(
                            child: Icon(Symbols.clock_loader_90_rounded,
                                size: 14, color: AppTheme.iconPale)),
                        const WidgetSpan(child: SizedBox(width: 4)),
                        const TextSpan(text: "1"),
                        const WidgetSpan(child: SizedBox(width: 8)),
                        const WidgetSpan(
                            child: Icon(Symbols.settings_rounded,
                                size: 14, color: AppTheme.iconRed)),
                        const WidgetSpan(child: SizedBox(width: 4)),
                        TextSpan(text: hull.cost.toString()),
                      ])),
                    ),
                  ],
                ),
              )),
        ));
  }
}
