import 'sim_props.dart';

enum WorkerType {
  economy(output: SimProps.credit),
  mining(output: SimProps.production),
  lab(output: SimProps.science);

  const WorkerType({required this.output});

  final Property output;
}

enum PlanetType {
  terran,
  desert,
  iron,
  ice,
  gas,
}

class WorkerSlot {
  WorkerType type;
  bool isOccupied;

  WorkerSlot({this.type = WorkerType.economy, this.isOccupied = false});
}

class Planet {
  final List<WorkerSlot> workerSlots;
  final PlanetType type;
  final bool isUnique;
  String name = "";

  Planet(this.type, this.workerSlots, {this.isUnique = false});

  bool hasWorker() {
    return workerSlots.any((slot) => slot.isOccupied);
  }

  factory Planet.terran() {
    return Planet(PlanetType.terran, [
      WorkerSlot(type: WorkerType.mining),
      WorkerSlot(),
      WorkerSlot(type: WorkerType.lab),
    ]);
  }

  factory Planet.desert() {
    return Planet(PlanetType.desert, [
      WorkerSlot(),
    ]);
  }

  factory Planet.iron() {
    return Planet(PlanetType.iron, [
      WorkerSlot(type: WorkerType.mining),
    ]);
  }

  factory Planet.ice() {
    return Planet(PlanetType.ice, [
      WorkerSlot(type: WorkerType.lab),
    ]);
  }

  factory Planet.gas() {
    return Planet(PlanetType.gas, [
      WorkerSlot(type: WorkerType.mining),
      WorkerSlot(),
    ]);
  }

  factory Planet.of(PlanetType type) {
    switch (type) {
      case PlanetType.terran:
        return Planet.terran();
      case PlanetType.desert:
        return Planet.desert();
      case PlanetType.iron:
        return Planet.iron();
      case PlanetType.ice:
        return Planet.ice();
      case PlanetType.gas:
        return Planet.gas();
    }
  }
}
