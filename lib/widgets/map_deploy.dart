import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:starflame/ship_blueprint.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/player_state.dart';
import 'package:starflame/select_control.dart';

class MapDeploy extends StatelessWidget {
  const MapDeploy(this.game, {super.key});

  static const id = 'map_deploy';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayerState>.value(
      value: game.controller.getHumanPlayerState(),
      child: Container(
          padding: const EdgeInsets.fromLTRB(4, 84, 0, 8),
          child: SingleChildScrollView(
            child: Consumer<PlayerState>(
              builder: (context, playerState, child) {
                return Column(
                  children: [
                    for (final hull in playerState.blueprints.where((bp) => bp.active && bp.buildable))
                      _addShipButton(playerState, hull)
                  ],
                );
              },
            ),
          )),
    );
  }

  Widget _addShipButton(PlayerState playerState, ShipBlueprint hull) {
    final isEnabled = game.resourceController.canCreateShip(
        game.controller.getHumanPlayerState().playerNumber, hull);
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
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(hull.className, style: textStyle)),
                    Expanded(child: Image.asset("assets/images/${hull.image}")),
                    Row(
                      children: [
                        const Text(
                          "\ue467",
                          style: AppTheme.icon16purple,
                        ),
                        const SizedBox(width: 4),
                        Text(playerState.nextActionCost.toString(),
                            style: textStyle),
                        const SizedBox(width: 8),
                        const Text(
                          "\ue1b1",
                          style: AppTheme.icon16red,
                        ),
                        const SizedBox(width: 4),
                        Text(hull.cost.toString(), style: textStyle)
                      ],
                    )
                  ],
                ),
              )),
        ));
  }
}
