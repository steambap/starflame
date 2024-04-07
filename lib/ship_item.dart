enum ShipItemType {
  weapon,
  util,
}

class ShipItem {
  final String name;
  final ShipItemType type;
  final int mass;
  final int cost;

  ShipItem({
    required this.name,
    required this.type,
    required this.mass,
    required this.cost,
  });
}

class ShipWeapon extends ShipItem {
  final int damage;
  final int shots;
  final int armorPenetration;
  final int maxRange;

  ShipWeapon({
    required super.name,
    required super.mass,
    required super.cost,
    required this.damage,
    this.shots = 1,
    required this.armorPenetration,
    required this.maxRange,
  }) : super(type: ShipItemType.weapon);
}

enum ShipItemSkill {
  life,
  lastStand,
  armorFlat,
  armorPercentage,
  damageReduction,
  damageAmplification,
  repairPerTurn,
  repairOnActionSelf,
  supply,
  movement,
  moral,
}

class ShipItemSkillValue {
  final ShipItemSkill skill;
  final int value;

  ShipItemSkillValue({
    required this.skill,
    required this.value,
  });
}

class ShipUtil extends ShipItem {
  final List<ShipItemSkillValue> skills;

  ShipUtil({
    required super.name,
    required super.mass,
    required super.cost,
    required this.skills,
  }) : super(type: ShipItemType.util);
}
