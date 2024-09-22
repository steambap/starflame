import "dart:convert";
import 'package:test/test.dart';

import "package:starfury/sim_props.dart";

class SimTest with SimObject {}

void main() {
  test("json works", () {
    var obj = SimTest();
    obj.addProp(SimProps.production, 10);
    obj.addProp(SimProps.production, 20);

    final jsonText = jsonEncode(obj.props);
    assert(jsonText == '{"production":30}');
  });
}
