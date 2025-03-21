import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:starflame/player_state.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:starflame/scifi_game.dart';
import 'package:starflame/research.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/data/tech.dart';

class ResearchOverlay extends StatelessWidget with WatchItMixin {
  const ResearchOverlay(this.game, {super.key});

  static const id = 'research_overlay';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    final playerState =
        watch<PlayerState>(game.controller.getHumanPlayerState());

    return Container(
      color: AppTheme.dialogBackground,
      child: Column(
        children: [
          SizedBox(
            height: AppTheme.navbarMargin,
            child: TextButton.icon(
                onPressed: () {
                  game.overlays.remove(id);
                },
                icon: const Icon(Symbols.cancel_rounded,
                    color: AppTheme.iconPale),
                label: const Text(
                  'Technology Screen',
                  style: AppTheme.label16,
                )),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _techRow(context, playerState, TechSection.science),
                _techRow(context, playerState, TechSection.industry),
                _techRow(context, playerState, TechSection.military),
                _techRow(context, playerState, TechSection.trade),
                _techRow(context, playerState, TechSection.empire),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _techRow(
      BuildContext context, PlayerState state, TechSection section) {
    final maxTechs = maxTechTable[section] ?? 10;

    return Row(
      spacing: 8,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: techColor(section),
            border: Border.all(color: techColor(section)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: techIcon(section),
        ),
        for (int i = 1; i <= maxTechs; i++)
          _techCell(context, state, section, i),
      ],
    );
  }

  Widget _techCell(
      BuildContext context, PlayerState state, TechSection section, int tier) {
    final currentLevel = state.techLevel[section] ?? 1;
    final buttonColor =
        tier <= currentLevel ? techColor(section) : AppTheme.techNotResearched;
    final borderColor =
        tier <= currentLevel ? techColor(section) : AppTheme.techBorder;
    final tech = techTable[section]![tier];
    final canResearch =
        game.resourceController.canResearch(state, section, tier);
    final Widget leftCell = tier <= currentLevel
        ? const Icon(Symbols.check_rounded, color: AppTheme.iconPale)
        : Text(
            Research.getCost(tier).toString(),
            style: AppTheme.label16,
          );

    return InkWell(
      splashColor: buttonColor,
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('${section.name} level $tier',
                  style: AppTheme.heading24),
              shape: const RoundedRectangleBorder(),
              content: Text(tech?.description ?? 'No Immediate Benefit',
                  style: AppTheme.label12),
              actions: [
                if (canResearch)
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    onPressed: () {
                      game.resourceController.doResearch(state, section, tier);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Research', style: AppTheme.label16),
                  ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel', style: AppTheme.label16),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: buttonColor,
              child: Center(
                child: leftCell,
              ),
            ),
            SizedBox(
              width: 60,
              child: tech == null
                  ? null
                  : Icon(tech.icon, color: AppTheme.iconPale),
            ),
          ],
        ),
      ),
    );
  }

  static Color techColor(TechSection section) {
    return switch (section) {
      TechSection.military => AppTheme.militaryTech,
      TechSection.science => AppTheme.scienceTech,
      TechSection.industry => AppTheme.industryTech,
      TechSection.trade => AppTheme.tradeTech,
      TechSection.empire => AppTheme.empireTech,
    };
  }

  static Icon techIcon(TechSection section) {
    return switch (section) {
      TechSection.military => const Icon(
          Symbols.swords_rounded,
          color: AppTheme.iconPale,
        ),
      TechSection.science => const Icon(
          Symbols.experiment_rounded,
          color: AppTheme.iconPale,
        ),
      TechSection.industry => const Icon(
          Symbols.settings_rounded,
          color: AppTheme.iconPale,
        ),
      TechSection.trade => const Icon(
          Symbols.copyright_rounded,
          color: AppTheme.iconPale,
        ),
      TechSection.empire => const Icon(
          Symbols.account_circle_rounded,
          color: AppTheme.iconPale,
        ),
    };
  }
}
