import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:starflame/scifi_game.dart';
import 'package:starflame/ship.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/select_control.dart';
import 'package:starflame/action_type.dart';

class ShipCmd extends StatelessWidget {
  const ShipCmd(this.game, {super.key});

  static const id = 'ship_cmd';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ValueNotifier<Ship?>>.value(
        value: game.hudState.ship,
        child: Positioned(
          bottom: 8,
          right: 124,
          child: Consumer<ValueNotifier<Ship?>>(
            builder: (context, shipValue, child) {
              return shipValue.value == null
                  ? const SizedBox.shrink()
                  : ChangeNotifierProvider<Ship>.value(
                      value: shipValue.value!,
                      child: Consumer<Ship>(
                        builder: (context, ship, child) => _renderShip(ship),
                      ),
                    );
            },
          ),
        ));
  }

  Widget _renderShip(Ship ship) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(children: [
          for (final act in ship.actions())
            Padding(
              padding: const EdgeInsets.all(4),
              child: IconButton.outlined(
                  onPressed: act.isDisabled(game)
                      ? null
                      : () {
                          if (act.targetType == ActionTarget.self) {
                            act.activate(game);
                          } else {
                            game.mapGrid.selectControl =
                                SelectControlWaitForAction(
                              act,
                              ship.cell,
                              game,
                            );
                          }
                        },
                  style: AppTheme.iconButton,
                  icon: act.icon),
            )
        ]),
        Container(
          width: 196,
          decoration: BoxDecoration(
              border: Border.all(
            color: AppTheme.panelBorder,
          )),
          child: _renderShipInfo(ship),
        ),
      ],
    );
  }

  Column _renderShipInfo(Ship ship) {
    return Column(
      children: [
        Container(
          width: 196,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: AppTheme.panelBorder,
          child: Text(ship.blueprint.className, style: AppTheme.label12),
        ),
        Row(
          children: [
            Image.asset("images/${ship.blueprint.image}"),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "\ue0f5",
                        style: AppTheme.icon16pale,
                      ),
                      const SizedBox(width: 4),
                      Text(
                          "${ship.state.health} / ${ship.blueprint.maxHealth()}",
                          style: AppTheme.label16),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "\ue127",
                        style: AppTheme.icon16pale,
                      ),
                      const SizedBox(width: 4),
                      Text("${ship.movePoint()} / ${ship.blueprint.movement()}",
                          style: AppTheme.label16),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "+${ship.blueprint.computers()} / -${ship.blueprint.countermeasures()}",
                  style: AppTheme.label12),
              const Text("computers", style: AppTheme.label12),
            ],
          ),
        ),
        if (ship.blueprint.cannons().isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("[${ship.blueprint.cannons().join(',')}]",
                    style: AppTheme.label12),
                const Text("cannons", style: AppTheme.label12),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
