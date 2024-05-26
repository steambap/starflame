enum ShipItemGroup {
  weapon,
  squadron,
  sensor,
  armor,
  support,
  engine,
}

class WeaponData {
  final List<int> damageAtRange;
  final int shots;
  final int armorPenetration;

  WeaponData({
    required this.damageAtRange,
    this.shots = 1,
    required this.armorPenetration,
  });
}

class ShipItemSkillValue {
  final ShipItemSkill skill;
  final int value;

  ShipItemSkillValue({
    required this.skill,
    required this.value,
  });
}

class ShipItem {
  final String name;
  final ShipItemGroup type;
  final int cost;
  final int energy;
  final List<ShipItemSkillValue> skills;
  final WeaponData? weaponData;

  ShipItem({
    required this.name,
    required this.type,
    this.cost = 0,
    this.energy = 0,
    this.skills = const [],
    this.weaponData,
  }) {
    if (isWeapon()) {
      assert(weaponData != null);
    }
  }

  bool isWeapon() => type == ShipItemGroup.weapon;
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
  engineering,
  movement,
  moral,
}
