import 'package:flutter/foundation.dart' show immutable;

// Resources that can be stockpiled
@immutable
class Resources {
  final int production;
  final int credit;
  final int science;

  const Resources(
      {this.production = 0,
      this.credit = 0,
      this.science = 0});

  Resources operator +(Resources other) {
    return Resources(
      production: production + other.production,
      credit: credit + other.credit,
      science: science + other.science,
    );
  }

  Resources operator *(int multiplier) {
    return Resources(
      production: production * multiplier,
      credit: credit * multiplier,
      science: science * multiplier,
    );
  }
}
