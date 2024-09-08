import 'package:flutter/foundation.dart' show immutable;

// Resources that can be stockpiled
@immutable
class Resources {
  final int maintaince;
  final int production;
  final int credit;
  final int science;
  final int transport;

  const Resources(
      {this.maintaince = 0,
      this.production = 0,
      this.credit = 0,
      this.science = 0,
      this.transport = 0});

  Resources operator +(Resources other) {
    return Resources(
      maintaince: maintaince + other.maintaince,
      production: production + other.production,
      credit: credit + other.credit,
      science: science + other.science,
      transport: transport + other.transport,
    );
  }

  Resources operator *(int multiplier) {
    return Resources(
      maintaince: maintaince * multiplier,
      production: production * multiplier,
      credit: credit * multiplier,
      science: science * multiplier,
      transport: transport * multiplier,
    );
  }
}
