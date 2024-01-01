import "dart:async";
import "dart:convert";

import "game_attribute.dart";
import "scifi_game.dart";
import "ship_type.dart";

class ShipData {
  final ShipType shipType;
  final int techLevel;
  final Map<GameAttribute, int> attr = {};

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
    shipData.attr[GameAttribute.cost] = input["cost"] as int;
    shipData.attr[GameAttribute.vision] = input["vision"] as int;
    shipData.attr[GameAttribute.health] = input["health"] as int;
    shipData.attr[GameAttribute.attack] = (input["attack"] as int?) ?? 0;
    shipData.hasDefaultWeapon = shipData.attr[GameAttribute.attack]! > 0;
    shipData.attr[GameAttribute.movementPoint] = input["movementPoint"] as int;
    shipData.attr[GameAttribute.minRange] = input["minRange"] as int;
    shipData.attr[GameAttribute.maxRange] = input["maxRange"] as int;

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

  (int, int) attackRange(ShipType shipType) {
    final shipData = table[shipType];
    if (shipData == null || !shipData.hasDefaultWeapon) {
      return (0, 0);
    }

    return (
      shipData.attr[GameAttribute.minRange]!,
      shipData.attr[GameAttribute.maxRange]!
    );
  }
}
