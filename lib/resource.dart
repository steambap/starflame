class Resources {
  int production;
  double credit;

  Resources({this.production = 0, this.credit = 0});

  Resources operator +(Resources other) {
    return Resources(
      production: production + other.production,
      credit: credit + other.credit,
    );
  }
}

class Income {
  int production;
  double credit;
  int influence;

  Income({this.production = 0, this.credit = 0, this.influence = 0});

  Income operator +(Income other) {
    return Income(
      production: production + other.production,
      credit: credit + other.credit,
      influence: influence + other.influence,
    );
  }
}
