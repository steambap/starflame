import "sim_props.dart";
import "player_state.dart";

class Research {
  final String id;
  final String displayName;
  final String description;
  final TechSection section;
  final int tier;
  final int cost;
  final Map<Property, int> effects;
  final String image;
  final void Function(PlayerState playerState)? provideBenefit;

  Research({
    required this.id,
    required this.displayName,
    this.description = "",
    required this.section,
    required this.tier,
    required this.cost,
    required this.effects,
    this.image = "",
    this.provideBenefit,
  });

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
  warfare,
  construction,
  nano,
}
