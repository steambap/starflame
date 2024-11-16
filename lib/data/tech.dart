import "../research.dart";
import "../sim_props.dart";

final List<Research> techs = [
  Research(
    id: "neutron_absorber",
    displayName: 'Neutron Absorber',
    tier: 0,
    section: TechSection.construction,
    cost: 4,
    effects: {
      SimProps.neutronDefense: 1,
    },
    description: 'Enemy [Neutron Bombs] have no effect on you.',
  ),
  Research(
      id: 'sector_defense',
      displayName: 'Sector Defense',
      section: TechSection.construction,
      tier: 0,
      cost: 4,
      effects: {
        SimProps.starbaseFreeUpdate: 1,
        SimProps.starbaseInitiative: 4,
      },
      description:
          'Starbases have +4 initiative and blueprint update is free.'),
  Research(
    id: "improved_hull",
    displayName: 'Improved Hull',
    tier: 1,
    section: TechSection.construction,
    cost: 6,
    effects: {
      SimProps.allowImprovedHull: 1,
    },
    description:
        'You may upgrade your ship blueprints with [Improved Hull] ship parts.',
  ),
  Research(
    id: "sentient_hull",
    displayName: 'Sentient Hull',
    tier: 1,
    section: TechSection.construction,
    cost: 7,
    effects: {
      SimProps.allowSentientHull: 1,
    },
    description:
        'You may upgrade your ship blueprints with [Sentient Hull] ship parts.',
  ),
  Research(
      id: 'anti-mass deflector',
      displayName: 'Anti-mass Deflector',
      section: TechSection.construction,
      tier: 2,
      cost: 8,
      effects: {
        SimProps.moveCostAsteroid: -5,
      },
      description: 'Your ships move through asteroid faster.'),
  Research(
    id: "fusion_drive",
    displayName: 'Fusion Drive',
    section: TechSection.construction,
    tier: 2,
    cost: 12,
    effects: {
      SimProps.allowFusionDrive: 1,
    },
    description:
        'You may upgrade your ship blueprints with [Fusion Drive] ship parts.',
  ),
  Research(
      id: 'absorption_shield',
      displayName: 'Absorption Shield',
      section: TechSection.construction,
      tier: 3,
      cost: 14,
      effects: {
        SimProps.allowAbsorptionShield: 1,
      },
      image: ''),
  Research(
    id: "tachyon_drive",
    displayName: 'Tachyon Drive',
    section: TechSection.construction,
    tier: 3,
    cost: 14,
    effects: {
      SimProps.allowTachyonDrive: 1,
    },
    description:
        'You may upgrade your ship blueprints with [Tachyon Drive] ship parts.',
  ),
  Research(
      id: 'climate_engineering',
      displayName: 'Climate Engineering',
      section: TechSection.construction,
      tier: 4,
      cost: 18,
      effects: {
        SimProps.allowTerraforming: 1,
      },
      description: 'You may terraform planets.'),
  Research(
      id: 'adaptive_colony_blueprint',
      displayName: 'Adaptive Colony Blueprint',
      section: TechSection.construction,
      tier: 4,
      cost: 18,
      effects: {
        SimProps.allowAdvancedSlot: 1,
      },
      description: 'You may colonize any advanced slot.'),
  Research(
      id: "electron_countermeasures",
      displayName: 'Electron Countermeasures',
      section: TechSection.nano,
      tier: 0,
      cost: 4,
      effects: {
        SimProps.allowElectronCountermeasures: 1,
      },
      description:
          'You may upgrade your ship blueprints with [Electron Countermeasures] ship parts.'),
  Research(
      id: "fusion_source",
      displayName: 'Fusion Source',
      section: TechSection.nano,
      tier: 0,
      cost: 4,
      effects: {
        SimProps.allowFusionSource: 1,
      },
      description:
          'You may upgrade your ship blueprints with [Fusion Source] ship parts.'),
  Research(
    id: "tachyon_source",
    displayName: 'Tachyon Source',
    section: TechSection.nano,
    tier: 3,
    cost: 12,
    effects: {
      SimProps.allowTachyonSource: 1,
    },
    description:
        'You may upgrade your ship blueprints with [Tachyon Source] ship parts.',
  ),
  Research(
      id: 'neutron_bombs',
      displayName: 'Neutron Bombs',
      section: TechSection.warfare,
      tier: 0,
      cost: 4,
      effects: {
        SimProps.neutronBombs: 1,
      },
      description:
          'You may use [Neutron Bombs] action, which destroys enemy colony.'),
  Research(
      id: 'ion_missile',
      displayName: 'Ion Missile',
      section: TechSection.warfare,
      tier: 0,
      cost: 4,
      effects: {
        SimProps.allowIonMissile: 1,
      },
      description:
          'You may upgrade your ship blueprints with [Ion Missile] ship parts.')
];

final Map<String, Research> techMap = {
  for (var tech in techs) tech.id: tech,
};
