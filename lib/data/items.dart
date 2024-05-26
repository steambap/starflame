import "../ship_item.dart";

final List<ShipItem> itemList = [
  // Weapons
  ShipItem(
      name: "Depleted Uranium Cannon",
      type: ShipItemGroup.weapon,
      weaponData:
          WeaponData(damageAtRange: [25], shots: 3, armorPenetration: 20),
      energy: -1),
  ShipItem(
      name: "Heavy Rail Cannon",
      type: ShipItemGroup.weapon,
      weaponData: WeaponData(damageAtRange: [55, 50], armorPenetration: 60),
      energy: -2),
  ShipItem(
      name: "Neutron Bomb",
      type: ShipItemGroup.weapon,
      weaponData: WeaponData(damageAtRange: [100, 65], armorPenetration: 20),
      energy: -2),
  ShipItem(
      name: "Flux Missle",
      type: ShipItemGroup.weapon,
      weaponData:
          WeaponData(damageAtRange: [30, 30], armorPenetration: 40, shots: 2),
      energy: -2),
  ShipItem(
      name: "Ripper Beam",
      type: ShipItemGroup.weapon,
      weaponData: WeaponData(
          damageAtRange: [20, 16, 12], armorPenetration: 45, shots: 8),
      energy: -4),
  ShipItem(
      name: "Plasma Cannon",
      type: ShipItemGroup.weapon,
      weaponData:
          WeaponData(damageAtRange: [25, 20], armorPenetration: 40, shots: 6),
      energy: -3),
  ShipItem(
      name: "Twin-Linked Rail Cannon",
      type: ShipItemGroup.weapon,
      weaponData: WeaponData(
          damageAtRange: [55, 50, 30], armorPenetration: 60, shots: 2),
      energy: -4),
  ShipItem(
      name: "Twin-Linked Flux Missle",
      type: ShipItemGroup.weapon,
      weaponData: WeaponData(
          damageAtRange: [30, 30, 30], armorPenetration: 40, shots: 4),
      energy: -4),
  ShipItem(
      name: "Pulse Laser",
      type: ShipItemGroup.weapon,
      weaponData:
          WeaponData(damageAtRange: [100, 100, 100], armorPenetration: 90),
      energy: -6),
  ShipItem(
      name: "Fusion Blaster",
      type: ShipItemGroup.weapon,
      weaponData:
          WeaponData(damageAtRange: [150, 150, 150], armorPenetration: 80),
      energy: -8),
  ShipItem(
      name: "Rail Cannon Array",
      type: ShipItemGroup.weapon,
      weaponData: WeaponData(
          damageAtRange: [55, 50, 30], armorPenetration: 60, shots: 4),
      energy: -7),
  ShipItem(name: "Core Protector", type: ShipItemGroup.armor, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.life, value: 10),
    ShipItemSkillValue(skill: ShipItemSkill.lastStand, value: 1),
  ]),
  ShipItem(name: "Armor Plating", type: ShipItemGroup.armor, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.armorFlat, value: 10),
  ]),
  ShipItem(name: "Emissive Armor", type: ShipItemGroup.armor, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.damageReduction, value: 5),
  ]),
  ShipItem(name: "Countermeasure sensor", type: ShipItemGroup.sensor, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.armorPercentage, value: 20),
  ]),
  ShipItem(name: "Long Range Scanner", type: ShipItemGroup.sensor, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.armorPercentage, value: 20),
  ]),
  ShipItem(name: "Nano Repair", type: ShipItemGroup.support, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.repairPerTurn, value: 2),
    ShipItemSkillValue(skill: ShipItemSkill.repairOnActionSelf, value: 40),
  ]),
  ShipItem(name: "Nuclear Engine", type: ShipItemGroup.engine, energy: 2),
  ShipItem(name: "Fusion Engine", type: ShipItemGroup.engine, energy: 3),
  ShipItem(name: "Ion Engine", type: ShipItemGroup.engine, energy: 5),
  ShipItem(name: "Tachyon Engine", type: ShipItemGroup.engine, energy: 8),
];

final Map<String, ShipItem> shipItemMap =
    Map.fromEntries(itemList.map((item) => MapEntry(item.name, item)));
