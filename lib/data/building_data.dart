import "../sim_props.dart";
import "../building.dart";

final colonyHQ = BuildingData(Building.colonyHQ, {
  SimProps.production: 3,
  SimProps.credit: 3,
  SimProps.science: 3,
  SimProps.maintainceCost: 1,
});
final constructionYard = BuildingData(Building.constructionYard, {
  SimProps.production: 6,
  SimProps.maintainceCost: 1,
});
final bank = BuildingData(Building.bank, {
  SimProps.credit: 6,
});
final lab = BuildingData(Building.lab, {
  SimProps.science: 6,
  SimProps.maintainceCost: 1,
});

final Map<Building, BuildingData> buildingTable = {
  Building.colonyHQ: colonyHQ,
  Building.constructionYard: constructionYard,
  Building.bank: bank,
  Building.lab: lab,
};
