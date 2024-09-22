import "../research.dart";
import "../sim_props.dart";

final List<Research> techs = [
  Research(
    id: "fusion_source",
    category: 0,
    displayName: 'Fusion Source',
    section: TechSection.grid,
    cost: 4,
    effects: {
      SimProps.allowFusionSource: 1,
    },
    image: '',
    description: 'You may Upgrade your Ship Blueprints with FUSION SOURCE Ship Parts.'
  ),
  Research(
    id: "fusion_drive",
    category: 0,
    displayName: 'Fusion Drive',
    section: TechSection.nano,
    cost: 4,
    effects: {
      SimProps.allowFusionDrive: 1,
    },
    image: '',
    description: 'You may Upgrade your Ship Blueprints with FUSION ORIVE Ship Parts.',
  ),
  Research(
    id: "tachyon_source",
    category: 0,
    displayName: 'Tachyon Source',
    section: TechSection.military,
    cost: 12,
    effects: {
      SimProps.allowTachyonSource: 1,
    },
    image: '',
    description: 'You may Upgrade your Ship Blueprints with TACHYON SOURCE Ship Parts.',
  ),
  Research(
    id: "tachyon_drive",
    category: 0,
    displayName: 'Tachyon Drive',
    section: TechSection.grid,
    cost: 12,
    effects: {
      SimProps.allowTachyonDrive: 1,
    },
    image: '',
    description: 'You may Upgrade your Ship Blueprints with TACHYONDRIVE Ship Parts.',
  ),
];

final Map<String, Research> techMap = {
  for (var tech in techs) tech.id: tech,
};

String getTechDesc(int category) {
  return switch (category) {
    0 => 'Propulsion',
    1 => 'Space habitats',
    2 => 'Sensors',
    10 => 'Weapon technology',
    20 => 'Defense technology',
    _ => 'Empire specific',
  };
}
