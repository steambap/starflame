import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'player_info.dart';
import 'sector_overlay.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/sector.dart';
import 'package:starflame/sim_props.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/data/lucide_icon.dart';

class SectorInfo extends StatelessWidget {
  const SectorInfo(this.game, {super.key});

  static const id = 'sector_info';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ValueNotifier<Sector?>>.value(
        value: game.hudState.sector,
        child: Positioned(
          bottom: 8,
          right: 132,
          child: Consumer<ValueNotifier<Sector?>>(
            builder: (context, sectorValue, child) {
              return sectorValue.value == null
                  ? const SizedBox.shrink()
                  : ChangeNotifierProvider<Sector>.value(
                      value: sectorValue.value!,
                      child: Consumer<Sector>(
                        builder: (context, sector, child) =>
                            _renderSector(sector),
                      ),
                    );
            },
          ),
        ));
  }

  Widget _renderSector(Sector sector) {
    final isPlayerSector =
        sector.playerNumber == game.controller.getHumanPlayerNumber();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: IconButton.outlined(
                onPressed: isPlayerSector
                    ? () {
                        game.overlays.remove(PlayerInfoBar.id);
                        game.overlays.add(SectorOverlay.id);
                        game.overlays.add(PlayerInfoBar.id);
                      }
                    : null,
                style: AppTheme.iconButton,
                icon: LucideIcon.orbit),
          )
        ]),
        Container(
          width: 196,
          decoration: BoxDecoration(
              border: Border.all(
            color: AppTheme.panelBorder,
          )),
          child: _renderSectorInfo(sector),
        )
      ],
    );
  }

  Widget _renderSectorInfo(Sector sector) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 196,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: AppTheme.panelBorder,
          child: Text(sector.displayName, style: AppTheme.label12),
        ),
        Wrap(
          spacing: 4,
          children: [
            if (sector.getProp(SimProps.support) != 0)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "\ue467",
                    style: AppTheme.icon16purple,
                  ),
                  Text(
                    "+${sector.getProp(SimProps.production)}",
                    style: AppTheme.label12,
                  ),
                ],
              ),
            if (sector.getProp(SimProps.production) != 0)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "\ue1b1",
                    style: AppTheme.icon16red,
                  ),
                  Text(
                    "+${sector.getProp(SimProps.production)}",
                    style: AppTheme.label12,
                  ),
                ],
              ),
            if (sector.getProp(SimProps.credit) != 0)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "\ue0bc",
                    style: AppTheme.icon16yellow,
                  ),
                  Text(
                    "+${sector.getProp(SimProps.credit)}",
                    style: AppTheme.label12,
                  ),
                ],
              ),
            if (sector.getProp(SimProps.science) != 0)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "\ue0db",
                    style: AppTheme.icon16blue,
                  ),
                  Text(
                    "+${sector.getProp(SimProps.science)}",
                    style: AppTheme.label12,
                  ),
                ],
              ),
          ],
        )
      ],
    );
  }
}
