import "dart:async";
import "dart:convert";

import "package:flame/components.dart";

import "action_type.dart";
import "scifi_game.dart";
import "ship_type.dart";

mixin ShipDataUpgradeable {
  int cost = 0;
  int vision = 0;
  int health = 0;
  int attack = 0;
  int movementPoint = 0;
  int minRange = 0;
  int maxRange = 0;
  List<ActionType> actions = [];
}

class ShipData with ShipDataUpgradeable {
  final ShipType shipType;
  final int techLevel;

  late final bool hasDefaultWeapon;

  ShipData(this.shipType, this.techLevel);
}

class ShipDataController {
  final ScifiGame game;
  final Map<ShipType, ShipData> table = {};

  ShipDataController(this.game);

  Future<void> loadData() async {
    final content = await game.assets.readFile("data/ship.json");

    final dataList = jsonDecode(content) as List<dynamic>;
    for (final data in dataList) {
      addData(data as Map<String, dynamic>);
    }

    return;
  }

  void addData(Map<String, dynamic> input) {
    final shipType = ShipType.values
        .firstWhere((element) => input["shipType"] == element.name);
    final techLevel = input["techLevel"] as int;
    final shipData = ShipData(shipType, techLevel);
    shipData.cost = input["cost"] as int;
    shipData.vision = input["vision"] as int;
    shipData.health = input["health"] as int;
    final attack = input["attack"] as int?;
    if (attack != null) {
      shipData.attack = attack;
    }
    shipData.hasDefaultWeapon = shipData.attack > 0;
    shipData.movementPoint = input["movementPoint"] as int;
    shipData.minRange = input["minRange"] as int;
    shipData.maxRange = input["maxRange"] as int;
    if (input["actions"] != null) {
      final shipActions = input["actions"] as List<dynamic>;
      for (final action in shipActions) {
        shipData.actions.add(
            ActionType.values.firstWhere((element) => action == element.name));
      }
    }

    if (shipData.hasDefaultWeapon) {
      shipData.actions.add(ActionType.capture);
    }

    table[shipType] = shipData;
  }

  bool isShipUnlocked(ShipType shipType, int playerNumber) {
    final shipData = table[shipType];
    if (shipData == null) {
      return false;
    }
    final techReq = game.controller.getPlayerState(playerNumber).techPoint;

    return shipData.techLevel <= techReq;
  }

  Block attackRange(ShipType shipType) {
    final shipData = table[shipType];
    if (shipData == null || !shipData.hasDefaultWeapon) {
      return const Block(0, 0);
    }

    return Block(shipData.minRange, shipData.maxRange);
  }
}
