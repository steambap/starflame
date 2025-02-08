import 'package:flutter/material.dart' show IconData;
import "sim_props.dart";
import "player_state.dart";

class Research {
  final int tier;
  final String description;
  final TechSection section;
  final Map<Property, int> effects;
  final IconData icon;
  final void Function(PlayerState playerState)? provideBenefit;

  Research({
    required this.tier,
    this.description = "",
    required this.section,
    required this.effects,
    required this.icon,
    this.provideBenefit,
  });

  static int getCost(int tier) {
    if (tier <= 5) {
      return tier + 4;
    }

    return tier * 3;
  }

  void applyBenefit(PlayerState playerState) {
    if (provideBenefit != null) {
      provideBenefit!(playerState);
    }

    for (final eff in effects.entries) {
      playerState.props.update(eff.key, (prev) => prev + eff.value,
          ifAbsent: () => eff.value);
    }
  }
}

enum TechSection {
  military,
  science,
  industry,
  trade,
  empire,
}
