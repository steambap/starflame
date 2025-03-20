import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

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
          left: 8,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(spacing: 4, children: [
          for (final act in ship.actions())
            IconButton.outlined(
                onPressed: act.isDisabled(game)
                    ? null
                    : () {
                        if (act.targetType == ActionTarget.self) {
                          act.activate(game);
                        } else {
                          game.mapGrid.selectControl =
                              SelectControlWaitForAction(
                            act,
                            game,
                          );
                        }
                      },
                style: AppTheme.iconButton,
                icon: Icon(act.icon))
        ]),
        const SizedBox(height: 4),
        Container(
          width: AppTheme.navbarWidth,
          decoration: BoxDecoration(
              color: AppTheme.panelBackground,
              border: Border.all(
                color: AppTheme.panelBorderDisabled,
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
          width: AppTheme.navbarWidth,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: AppTheme.panelTitle,
          child: Text(ship.blueprint.className, style: AppTheme.label12),
        ),
        Row(
          children: [
            SpriteWidget(
              sprite: Sprite(game.images.fromCache(ship.blueprint.image),
                  srcSize: Vector2.all(72)),
              anchor: Anchor.center,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RichText(
                          text: TextSpan(style: AppTheme.label16, children: [
                        const WidgetSpan(
                            child: Icon(Symbols.favorite_rounded,
                                size: 16, color: AppTheme.iconPale)),
                        const WidgetSpan(child: SizedBox(width: 4)),
                        TextSpan(
                            text:
                                "${ship.state.health} / ${ship.blueprint.maxHealth()}"),
                      ])),
                    ],
                  ),
                  Row(
                    children: [
                      RichText(
                          text: TextSpan(style: AppTheme.label16, children: [
                        const WidgetSpan(
                            child: Icon(Symbols.near_me_rounded,
                                size: 16, color: AppTheme.iconPale)),
                        const WidgetSpan(child: SizedBox(width: 4)),
                        TextSpan(
                            text:
                                "${ship.movePoint()} / ${ship.blueprint.movement()}"),
                      ])),
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
        if (ship.blueprint.cannons().isNotEmpty)
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
    );
  }
}
