import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starflame/player_state.dart';

import 'package:starflame/scifi_game.dart';
import 'package:starflame/research.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/data/tech.dart';

class ResearchOverlay extends StatelessWidget {
  const ResearchOverlay(this.game, {super.key});

  static const id = 'research_overlay';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.dialogBackground,
      child: Column(
        children: [
          const SizedBox(
            height: navbarHeight,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    game.overlays.remove(id);
                  },
                  child: const Text(
                    'x',
                    style: AppTheme.label16,
                  ))),
          ChangeNotifierProvider<PlayerState>.value(
            value: game.controller.getHumanPlayerState(),
            child: Consumer<PlayerState>(
              builder: (context, value, child) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _techColumn(context, value, TechSection.warfare),
                  const SizedBox(
                    width: 8,
                  ),
                  _techColumn(context, value, TechSection.construction),
                  const SizedBox(
                    width: 8,
                  ),
                  _techColumn(context, value, TechSection.nano),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _techColumn(
      BuildContext context, PlayerState state, TechSection section) {
    final double colWidth =
        MediaQuery.of(context).size.width > 1024 ? 288 : 216;
    final selectedTechs = techs
        .where((t) =>
            (t.section == section) && (t.tier == state.techLevel[section]))
        .toList()
        .sublist(0, 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: colWidth,
          height: 24,
          color: techColor(section),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            section.name,
            style: AppTheme.label12,
          ),
        ),
        for (final tech in selectedTechs) _techCell(state, tech, colWidth),
      ],
    );
  }

  Widget _techCell(PlayerState state, Research tech, double width) {
    final isEnabled = game.resourceController.canResearch(
        game.controller.getHumanPlayerState().playerNumber, tech.id);
    final textStyle = isEnabled ? AppTheme.label12 : AppTheme.label12Gray;

    return Container(
      padding: const EdgeInsets.all(4),
      width: width,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppTheme.panelBorder,
          ),
          bottom: BorderSide(
            color: AppTheme.panelBorder,
          ),
          right: BorderSide(
            color: AppTheme.panelBorder,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tech.displayName,
            style: AppTheme.label16,
          ),
          SizedBox(
              height: 72,
              child: Text(
                tech.description,
                style: AppTheme.label12,
              )),
          Row(
            children: [
              const Text(
                "\ue467",
                style: AppTheme.icon16purple,
              ),
              const SizedBox(width: 4),
              Text(state.nextActionCost.toString(), style: textStyle),
              const SizedBox(width: 8),
              const Text(
                "\ue0db",
                style: AppTheme.icon16blue,
              ),
              const SizedBox(width: 4),
              Text(tech.cost.toString(), style: textStyle)
            ],
          )
        ],
      ),
    );
  }

  static Color techColor(TechSection section) {
    return switch (section) {
      TechSection.warfare => AppTheme.warfareTech,
      TechSection.construction => AppTheme.constructionTech,
      TechSection.nano => AppTheme.nanoTech,
    };
  }
}
