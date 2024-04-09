enum Building {
  colonyHQ(
      cost: 1500,
      uniqueTag: 'unique',
      displayName: "Colony Base",
      image: 'colony_hq.png'),

  policeStation(
      cost: 100, displayName: "Police Station", image: 'police_station.png'),
  constructionYard(
      cost: 250,
      displayName: "Construction Yard",
      image: 'construction_yard.png'),
  fusionReactor(
      cost: 100, displayName: "Fusion Reactor", image: 'fusion_reactor.png'),
  mediaNetwork(
      cost: 200, displayName: "Media Network", image: 'media_network.png'),
  tradeCompany(
      cost: 300, displayName: "Trade Company", image: 'trade_company.png');

  const Building({
    required this.cost,
    this.uniqueTag = "",
    required this.displayName,
    required this.image,
  });

  final int cost;
  final String uniqueTag;
  final String displayName;

  final String image;
}
