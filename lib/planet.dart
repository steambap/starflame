import 'sim_props.dart';

enum WorkerType {
  support(output: SimProps.support),
  economy(output: SimProps.credit),
  mining(output: SimProps.production),
  lab(output: SimProps.science);

  const WorkerType({
    required this.output
  });

  final Property output;
}

enum PlanetType {
  terran,
  desert,
  iron,
  ice,
  gas,
  orbital,
}

class WorkerSlot {
  WorkerType type;
  bool isOccupied;
  bool isAdvanced;

  WorkerSlot(
      {this.type = WorkerType.economy,
      this.isOccupied = false,
      this.isAdvanced = false});
}

int slotOutput(Planet planet, WorkerType wType) {
  return switch (planet.type) {
    PlanetType.terran => switch (wType) {
        WorkerType.support => Planet.output2,
        WorkerType.economy => Planet.output2,
        WorkerType.mining => Planet.output1,
        WorkerType.lab => Planet.output2,
      },
    PlanetType.desert => switch (wType) {
        WorkerType.support => Planet.output1,
        WorkerType.economy => Planet.output2,
        WorkerType.mining => Planet.output1,
        WorkerType.lab => Planet.output1,
      },
    PlanetType.iron => switch (wType) {
        WorkerType.support => Planet.output1,
        WorkerType.economy => Planet.output1,
        WorkerType.mining => Planet.output2,
        WorkerType.lab => Planet.output1,
      },
    PlanetType.ice => switch (wType) {
        WorkerType.support => Planet.output1,
        WorkerType.economy => Planet.output1,
        WorkerType.mining => Planet.output1,
        WorkerType.lab => Planet.output2,
      },
    PlanetType.gas => switch (wType) {
        WorkerType.support => Planet.output1,
        WorkerType.economy => Planet.output2,
        WorkerType.mining => Planet.output2,
        WorkerType.lab => Planet.output2,
      },
    PlanetType.orbital => switch (wType) {
        WorkerType.support => Planet.output1,
        WorkerType.economy => Planet.output2,
        WorkerType.mining => Planet.output1,
        WorkerType.lab => Planet.output2,
      }
  };
}

class Planet {
  static const output1 = 1;
  static const output2 = 2;

  final List<WorkerSlot> workerSlots;
  final PlanetType type;
  final bool isUnique;
  String name = "";

  Planet(this.type, this.workerSlots, {this.isUnique = false});

  factory Planet.terran() {
    return Planet(PlanetType.terran, [
      WorkerSlot(),
      WorkerSlot(),
    ]);
  }

  factory Planet.desert11() {
    return Planet(PlanetType.desert, [
      WorkerSlot(),
      WorkerSlot(isAdvanced: true),
    ]);
  }

  factory Planet.desert10() {
    return Planet(PlanetType.desert, [
      WorkerSlot(),
    ]);
  }

  factory Planet.desert01() {
    return Planet(PlanetType.desert, [
      WorkerSlot(isAdvanced: true),
    ]);
  }

  factory Planet.iron11() {
    return Planet(PlanetType.iron, [
      WorkerSlot(type: WorkerType.mining),
      WorkerSlot(type: WorkerType.mining, isAdvanced: true),
    ]);
  }

  factory Planet.iron10() {
    return Planet(PlanetType.iron, [
      WorkerSlot(type: WorkerType.mining),
    ]);
  }

  factory Planet.iron01() {
    return Planet(PlanetType.iron, [
      WorkerSlot(type: WorkerType.mining, isAdvanced: true),
    ]);
  }

  factory Planet.ice11() {
    return Planet(PlanetType.ice, [
      WorkerSlot(type: WorkerType.lab),
      WorkerSlot(type: WorkerType.lab, isAdvanced: true),
    ]);
  }

  factory Planet.ice10() {
    return Planet(PlanetType.ice, [
      WorkerSlot(type: WorkerType.lab),
    ]);
  }

  factory Planet.ice01() {
    return Planet(PlanetType.ice, [
      WorkerSlot(type: WorkerType.lab, isAdvanced: true),
    ]);
  }

  factory Planet.gas10() {
    return Planet(PlanetType.gas, [
      WorkerSlot(),
    ]);
  }

  factory Planet.gas01() {
    return Planet(PlanetType.gas, [
      WorkerSlot(isAdvanced: true),
    ]);
  }

  factory Planet.orbital() {
    return Planet(PlanetType.orbital, [
      WorkerSlot(),
    ]);
  }
}
