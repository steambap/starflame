import 'package:starflame/building.dart';
import 'package:starflame/resource.dart';
import 'package:starflame/sim_props.dart';

final buildingTable = <String, BuildingData>{
  "TownHall": BuildingData(
    name: "TownHall",
    bType: BuildingType.civilian,
    isUnique: true,
    noMaintenance: false,
    noUpgrade: false,
    cost: const Resources(production: 25),
    description: "TownHall.",
    obj: {
      SimProps.energy: 1,
      SimProps.production: 1,
      SimProps.politics: 1,
    },
  ),
  "Factory": BuildingData(
    name: "Factory",
    bType: BuildingType.military,
    isUnique: false,
    noMaintenance: false,
    noUpgrade: false,
    cost: const Resources(production: 5),
    description: "Factory.",
    obj: {
      SimProps.production: 1,
      SimProps.productionLimit: 5,
    },
  ),
  "Market": BuildingData(
    name: "Market",
    bType: BuildingType.civilian,
    isUnique: false,
    noMaintenance: true,
    noUpgrade: false,
    cost: const Resources(production: 5),
    description: "Market.",
    obj: {
      SimProps.energy: 1,
    },
  ),
};
