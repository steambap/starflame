import "../ship_item.dart";

final List<ShipItem> itemList = [
  // Weapons
  ShipWeapon(
      name: "Depleted Uranium Cannon",
      damage: 25,
      armorPenetration: 20,
      mass: 55,
      maxRange: 2,
      cost: 250),
  ShipWeapon(
      name: "Heavy Rail Cannon",
      damage: 35,
      armorPenetration: 55,
      mass: 100,
      maxRange: 2,
      cost: 350),
  ShipWeapon(
      name: "Flamer",
      damage: 65,
      armorPenetration: 20,
      mass: 105,
      maxRange: 2,
      cost: 450),
  ShipWeapon(
      name: "Missle Launcher",
      damage: 30,
      shots: 2,
      armorPenetration: 40,
      mass: 95,
      maxRange: 2,
      cost: 550),
  ShipWeapon(
      name: "Heavy Missle Launcher",
      damage: 30,
      shots: 3,
      armorPenetration: 40,
      mass: 170,
      maxRange: 3,
      cost: 750),
  ShipWeapon(
      name: "Ripper Beam",
      damage: 18,
      shots: 8,
      armorPenetration: 45,
      mass: 200,
      maxRange: 3,
      cost: 1000),
  ShipWeapon(
      name: "Plasma Gun",
      damage: 25,
      shots: 6,
      armorPenetration: 40,
      mass: 140,
      maxRange: 2,
      cost: 850),
  ShipWeapon(
      name: "Twin-Linked Rail Cannon",
      damage: 30,
      shots: 2,
      armorPenetration: 60,
      mass: 180,
      maxRange: 3,
      cost: 700),
  ShipWeapon(
      name: "Twin-Linked Missle Launcher",
      damage: 30,
      shots: 4,
      armorPenetration: 40,
      mass: 200,
      maxRange: 3,
      cost: 850),
  ShipWeapon(
      name: "Sync Laser",
      damage: 160,
      armorPenetration: 90,
      mass: 300,
      maxRange: 3,
      cost: 1150),
  ShipWeapon(
      name: "Fusion Blaster",
      damage: 150,
      armorPenetration: 80,
      mass: 400,
      maxRange: 4,
      cost: 1400),
  ShipWeapon(
      name: "Rail Cannon Array",
      damage: 60,
      shots: 3,
      armorPenetration: 60,
      mass: 350,
      maxRange: 4,
      cost: 1450),
  ShipUtil(name: "Core Protector", mass: 50, cost: 200, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.life, value: 10),
    ShipItemSkillValue(skill: ShipItemSkill.lastStand, value: 1),
  ]),
  ShipUtil(name: "Armor Plating", mass: 35, cost: 150, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.armorFlat, value: 5),
  ]),
  ShipUtil(name: "Reactive Armor", mass: 60, cost: 250, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.damageReduction, value: 5),
    ShipItemSkillValue(skill: ShipItemSkill.movement, value: -1),
  ]),
  ShipUtil(name: "Advanced Hull Armor", mass: 150, cost: 500, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.armorPercentage, value: 20),
  ]),
  ShipUtil(name: "Reactor Booster", mass: 50, cost: 200, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.damageAmplification, value: 10),
    ShipItemSkillValue(skill: ShipItemSkill.movement, value: -1),
  ]),
  ShipUtil(name: "Nano repair", mass: 50, cost: 250, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.repairPerTurn, value: 2),
    ShipItemSkillValue(skill: ShipItemSkill.repairOnActionSelf, value: 40),
  ]),
  ShipUtil(name: "Engineering Kit", mass: 50, cost: 300, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.supply, value: 50),
  ]),
  ShipUtil(name: "Engineering package", mass: 150, cost: 900, skills: [
    ShipItemSkillValue(skill: ShipItemSkill.supply, value: 150),
  ]),
];

final Map<String, ShipItem> itemTable =
    itemList.asMap().map((index, item) => MapEntry(item.name, item));
