class Resources {
  int production;
  double credit;
  int influence;

  Resources({this.production = 0, this.credit = 0, this.influence = 0});

  Resources operator + (Resources other) {
    return Resources(
      production: production + other.production,
      credit: credit + other.credit,
      influence: influence + other.influence,
    );
  }
}
