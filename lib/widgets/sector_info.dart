import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'player_info.dart';
import 'sector_overlay.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/sector.dart';
import 'package:starflame/sim_props.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/fmt.dart';
import 'package:starflame/hud_state.dart';

class SectorInfo extends StatelessWidget with WatchItMixin {
  const SectorInfo(this.game, {super.key});

  static const id = 'sector_info';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    final sector = watchValue((HudState x) => x.sector);

    return Positioned(
      bottom: 8,
      left: 8,
      child: sector == null
          ? const SizedBox.shrink()
          : _renderSector(sector),
    );
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
                icon: const Icon(Symbols.planet_rounded)),
          )
        ]),
        Container(
          width: AppTheme.navbarWidth,
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
          width: AppTheme.navbarWidth,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: AppTheme.panelBorder,
          child: Text(sector.displayName, style: AppTheme.label12),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: RichText(
              text: TextSpan(style: AppTheme.label12, children: [
            if (sector.getProp(SimProps.support) != 0)
              const WidgetSpan(
                  child: Icon(Symbols.account_circle_rounded,
                      size: 16, color: AppTheme.iconPurple)),
            if (sector.getProp(SimProps.support) != 0)
              TextSpan(
                  text:
                      " ${formatterSigned.format(sector.getProp(SimProps.support))}  "),
            if (sector.getProp(SimProps.production) != 0)
              const WidgetSpan(
                  child: Icon(Symbols.settings_rounded,
                      size: 16, color: AppTheme.iconRed)),
            if (sector.getProp(SimProps.production) != 0)
              TextSpan(
                  text:
                      " ${formatterSigned.format(sector.getProp(SimProps.production))} "),
            if (sector.getProp(SimProps.credit) != 0)
              const WidgetSpan(
                  child: Icon(Symbols.copyright_rounded,
                      size: 16, color: AppTheme.iconYellow)),
            if (sector.getProp(SimProps.credit) != 0)
              TextSpan(
                  text:
                      " ${formatterSigned.format(sector.getProp(SimProps.credit))} "),
            if (sector.getProp(SimProps.science) != 0)
              const WidgetSpan(
                  child: Icon(Symbols.experiment_rounded,
                      size: 16, color: AppTheme.iconBlue)),
            if (sector.getProp(SimProps.science) != 0)
              TextSpan(
                  text:
                      " ${formatterSigned.format(sector.getProp(SimProps.science))} "),
          ])),
        ),
      ],
    );
  }
}
