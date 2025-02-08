import "package:starflame/research.dart";
import "package:starflame/planet.dart";
// import "../sim_props.dart";
import "./lucide_icon.dart";

final List<Research> scienceTechs = [
  Research(
    tier: 1,
    description: "Can colonize ice planets.",
    section: TechSection.science,
    effects: {},
    icon: LucideIcon.earth,
    provideBenefit: (playerState) {
      playerState.colonizable.add(PlanetType.ice);
    },
  ),
  Research(
    tier: 2,
    description: "Unlocks the ability to build lab.",
    section: TechSection.science,
    effects: {},
    icon: LucideIcon.microscope,
  ),
  Research(
    tier: 5,
    description: "Unlocks the ability to build lab.",
    section: TechSection.science,
    effects: {},
    icon: LucideIcon.microscope,
  ),
  Research(
    tier: 8,
    description: "Unlocks the ability to build lab.",
    section: TechSection.science,
    effects: {},
    icon: LucideIcon.microscope,
  ),
];

final Map<int, Research> scienceTechMap = {
  for (final tech in scienceTechs) tech.tier: tech,
};

final List<Research> industryTechs = [
  Research(
    tier: 1,
    description: "Unlocks the ability to build factory.",
    section: TechSection.industry,
    effects: {},
    icon: LucideIcon.factory,
  ),
  Research(
    tier: 2,
    description: "Can colonize iron planets.",
    section: TechSection.science,
    effects: {},
    icon: LucideIcon.earth,
    provideBenefit: (playerState) {
      playerState.colonizable.add(PlanetType.iron);
    },
  ),
  Research(
    tier: 4,
    description: "Unlocks the ability to build factory.",
    section: TechSection.industry,
    effects: {},
    icon: LucideIcon.factory,
  ),
  Research(
    tier: 7,
    description: "Unlocks the ability to build factory.",
    section: TechSection.industry,
    effects: {},
    icon: LucideIcon.factory,
  ),
];

final Map<int, Research> industryTechMap = {
  for (final tech in industryTechs) tech.tier: tech,
};

final List<Research> militaryTechs = [
  Research(
    tier: 2,
    description: "Unlocks new ship.",
    section: TechSection.military,
    effects: {},
    icon: LucideIcon.swords,
  ),
  Research(
    tier: 7,
    description: "Unlocks new ship.",
    section: TechSection.military,
    effects: {},
    icon: LucideIcon.swords,
  ),
  Research(
    tier: 12,
    description: "Unlocks new ship.",
    section: TechSection.military,
    effects: {},
    icon: LucideIcon.swords,
  ),
];

final Map<int, Research> militaryTechMap = {
  for (final tech in militaryTechs) tech.tier: tech,
};

final List<Research> tradeTechs = [
  Research(
    tier: 1,
    description: "Can colonize desert planets.",
    section: TechSection.trade,
    effects: {},
    icon: LucideIcon.earth,
    provideBenefit: (playerState) {
      playerState.colonizable.add(PlanetType.desert);
    },
  ),
  Research(
    tier: 2,
    description: "Unlocks the ability to build bank.",
    section: TechSection.trade,
    effects: {},
    icon: LucideIcon.store,
  ),
  Research(
    tier: 6,
    description: "Unlocks the ability to build bank.",
    section: TechSection.trade,
    effects: {},
    icon: LucideIcon.store,
  ),
  Research(
    tier: 10,
    description: "Unlocks the ability to build bank.",
    section: TechSection.trade,
    effects: {},
    icon: LucideIcon.store,
  ),
];

final Map<int, Research> tradeTechMap = {
  for (final tech in tradeTechs) tech.tier: tech,
};

final List<Research> empireTechs = [
  Research(
    tier: 1,
    description: "Unlocks the ability to build farm.",
    section: TechSection.empire,
    effects: {},
    icon: LucideIcon.wheat,
  ),
  Research(
    tier: 3,
    description: "Can colonize gas planets.",
    section: TechSection.empire,
    effects: {},
    icon: LucideIcon.earth,
    provideBenefit: (playerState) {
      playerState.colonizable.add(PlanetType.gas);
    },
  ),
  Research(
    tier: 4,
    description: "Unlocks the ability to build farm.",
    section: TechSection.empire,
    effects: {},
    icon: LucideIcon.wheat,
  ),
  Research(
    tier: 7,
    description: "Unlocks the ability to build farm.",
    section: TechSection.empire,
    effects: {},
    icon: LucideIcon.wheat,
  ),
];

final Map<int, Research> empireTechMap = {
  for (final tech in empireTechs) tech.tier: tech,
};

final Map<TechSection, Map<int, Research>> techTable = {
  TechSection.science: scienceTechMap,
  TechSection.industry: industryTechMap,
  TechSection.military: militaryTechMap,
  TechSection.trade: tradeTechMap,
  TechSection.empire: empireTechMap,
};

final Map<TechSection, int> maxTechTable = {
  TechSection.science: 10,
  TechSection.industry: 10,
  TechSection.military: 12,
  TechSection.trade: 10,
  TechSection.empire: 10,
};
