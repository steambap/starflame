import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:starflame/select_control.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/sector.dart';
import 'package:starflame/planet.dart';
import 'package:starflame/sim_props.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/fmt.dart';
import 'package:starflame/hud_state.dart';

class SectorInfo extends StatefulWidget with WatchItStatefulWidgetMixin {
  const SectorInfo(this.game, {super.key});

  static const id = 'sector_info';

  final ScifiGame game;

  @override
  State<SectorInfo> createState() => _SectorInfoState();
}

class _SectorInfoState extends State<SectorInfo> {
  int sheetIndex = -1;

  @override
  Widget build(BuildContext context) {
    final sector = watchValue((HudState x) => x.sector);

    return sector == null ? const SizedBox.shrink() : _renderSector(sector);
  }

  Widget _renderSector(Sector sector) {
    final isPlayerSector =
        sector.playerNumber == widget.game.controller.getHumanPlayerNumber();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
              color: AppTheme.panelBackground,
              border: Border.all(
                color: AppTheme.panelBorder,
              )),
          child: _renderSectorInfo(sector),
        ),
        isPlayerSector ? _bottomSheet(sector) : const SizedBox.shrink(),
      ],
    );
  }

  Widget _renderSectorInfo(Sector sector) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppTheme.panelTitle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: () {
                    widget.game.mapGrid.selectControl =
                        SelectControlWaitForInput(widget.game);
                  },
                  icon: const Icon(Symbols.cancel_rounded,
                      color: AppTheme.iconPale),
                  label: Text(
                    sector.displayName,
                    style: AppTheme.label16,
                  )),
              if (sector.isHome())
                const Icon(Symbols.crown_rounded,
                    size: 16, color: AppTheme.iconYellow),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: const BoxDecoration(
                      color: AppTheme.panelBorderDisabled,
                    ),
                    child: Row(
                      children: [
                        Text("${sector.planets.length} planets in the sector",
                            style: AppTheme.label12),
                      ],
                    )),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("total planets: ${sector.planets.length}",
                                style: AppTheme.label12),
                            Text(
                                "habitable: ${sector.getHabitablePlanets().length} / inhabited: ${sector.getInhabitablePlanets().length}",
                                style: AppTheme.label12),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              sheetIndex = 0;
                            });
                          },
                          icon: const Icon(Symbols.planet_rounded,
                              color: AppTheme.iconPale),
                          style: AppTheme.iconButton,
                        ),
                      ],
                    )),
              ],
            )),
            // Center
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: const BoxDecoration(
                  color: AppTheme.panelTitle,
                  border: Border(
                    left: BorderSide(color: AppTheme.panelBorderDisabled),
                    right: BorderSide(color: AppTheme.panelBorderDisabled),
                  ),
                ),
                child: Column(
                  children: [
                    RichText(
                        text: TextSpan(style: AppTheme.label12, children: [
                      if (sector.getProp(SimProps.production) != 0)
                        const WidgetSpan(
                            child: Icon(Symbols.settings_rounded,
                                size: 16, color: AppTheme.iconRed)),
                      if (sector.getProp(SimProps.production) != 0)
                        TextSpan(
                            text:
                                " ${formatterSigned.format(sector.getProp(SimProps.production))} "),
                      if (sector.getProp(SimProps.energy) != 0)
                        const WidgetSpan(
                            child: Icon(Symbols.bolt_rounded,
                                size: 16, color: AppTheme.iconYellow)),
                      if (sector.getProp(SimProps.energy) != 0)
                        TextSpan(
                            text:
                                " ${formatterSigned.format(sector.getProp(SimProps.energy))} "),
                      if (sector.getProp(SimProps.politics) != 0)
                        const WidgetSpan(
                            child: Icon(Symbols.stars_rounded,
                                size: 16, color: AppTheme.iconBlue)),
                      if (sector.getProp(SimProps.politics) != 0)
                        TextSpan(
                            text:
                                " ${formatterSigned.format(sector.getProp(SimProps.politics))} "),
                    ])),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  sheetIndex = 2;
                                });
                              },
                              icon: const Icon(Symbols.trending_up_rounded,
                                  color: AppTheme.iconPale),
                              style: AppTheme.iconButton,
                            ),
                            const Column(
                              children: [
                                Text(
                                  "Invest",
                                  style: AppTheme.label12,
                                ),
                                Text(
                                  "Invest",
                                  style: AppTheme.label12,
                                ),
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
            // Right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: const BoxDecoration(
                      color: AppTheme.panelBorderDisabled,
                    ),
                    child: Row(
                      children: [
                        Text("${sector.starType.name} star",
                            style: AppTheme.label12),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                sheetIndex = 1;
                              });
                            },
                            icon: const Icon(Symbols.developer_board_rounded,
                                color: AppTheme.iconPale),
                            style: AppTheme.iconButton,
                          ),
                          const VerticalDivider(
                            color: AppTheme.panelBorder,
                            thickness: 1,
                          ),
                          Column(
                            children: [
                              Text(
                                "Buildings: ${sector.getBuildingCount()} / 6",
                                style: AppTheme.label12,
                              ),
                              Text(
                                "Buildings: ${sector.getBuildingCount()} / 6",
                                style: AppTheme.label12,
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _actionSheet(Sector sector) {
    switch (sheetIndex) {
      case 0:
        return _renderPlanets(sector);
      case 1:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _renderPlanets(Sector sector) {
    return Center(
      child: Row(mainAxisSize: MainAxisSize.min,children: [
        for (final planet in sector.planets)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(planet.type  == PlanetType.habitable
                ? 'assets/images/terran.png'
                : 'assets/images/gas.png',
                width: 64, height: 64, fit: BoxFit.cover),
          ),
      ],),
    );
  }

  Widget _bottomSheet(Sector sector) {
    return Column(
      spacing: 16,
      children: [
        _actionSheet(sector),
        Container(
          decoration: const BoxDecoration(
              color: AppTheme.panelBackground,
              border: Border.symmetric(
                  horizontal: BorderSide(color: AppTheme.panelBorder))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    sheetIndex = 0;
                  });
                },
                style: AppTheme.textButton,
                icon: const Icon(Symbols.planet_rounded),
                label: const Text('Planets'),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    sheetIndex = 1;
                  });
                },
                style: AppTheme.textButton,
                icon: const Icon(Symbols.developer_board_rounded),
                label: const Text('Buildings'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
