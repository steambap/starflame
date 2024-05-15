enum Building {
  colonyHQ(
      cost: 150,
      uniqueTag: 'unique',
      displayName: "Colony Base",
      image: 'colony_hq.png'),

  constructionYard(
      cost: 25,
      displayName: "Construction Yard",
      image: 'construction_yard.png'),
  bank(cost: 15, displayName: "Bank", image: 'bank.png'),
  lab(
      cost: 20,
      displayName: "Research Lab",
      image: 'lab.png',
      uniqueTag: 'lab'),
  mediaNetwork(
      cost: 20,
      displayName: "Media Network",
      image: 'media_network.png',
      uniqueTag: 'media_network');

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
