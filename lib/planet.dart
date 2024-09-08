enum WorkerType {
  economy,
  mining,
  lab,
}

enum PlanetType {
  temperate,
  hot,
  cold,
  gas,
  orbital,
}

class WorkerSlot {
  static const output = 2;

  Set<WorkerType> allowedTypes;
  WorkerType type;
  bool isOccupied;
  bool isAdvanced;

  WorkerSlot(this.allowedTypes,
      {this.type = WorkerType.economy,
      this.isOccupied = false,
      this.isAdvanced = false});
}

class Planet {
  final List<WorkerSlot> workerSlots;
  final PlanetType type;
  final bool isUnique;
  String name = "";

  Planet(this.type, this.workerSlots, {this.isUnique = false});

  factory Planet.economy11() {
    return Planet(PlanetType.temperate, [
      WorkerSlot({WorkerType.economy}),
      WorkerSlot({WorkerType.economy}, isAdvanced: true),
    ]);
  }

  factory Planet.economy10() {
    return Planet(PlanetType.temperate, [
      WorkerSlot({WorkerType.economy}),
    ]);
  }

  factory Planet.economy01() {
    return Planet(PlanetType.temperate, [
      WorkerSlot({WorkerType.economy}, isAdvanced: true),
    ]);
  }

  factory Planet.mining11() {
    return Planet(PlanetType.hot, [
      WorkerSlot({WorkerType.mining}, type: WorkerType.mining),
      WorkerSlot({WorkerType.mining},
          type: WorkerType.mining, isAdvanced: true),
    ]);
  }

  factory Planet.mining10() {
    return Planet(PlanetType.hot, [
      WorkerSlot({WorkerType.mining}, type: WorkerType.mining),
    ]);
  }

  factory Planet.mining01() {
    return Planet(PlanetType.hot, [
      WorkerSlot({WorkerType.mining},
          type: WorkerType.mining, isAdvanced: true),
    ]);
  }

  factory Planet.lab11() {
    return Planet(PlanetType.cold, [
      WorkerSlot({WorkerType.lab}, type: WorkerType.lab),
      WorkerSlot({WorkerType.lab}, type: WorkerType.lab, isAdvanced: true),
    ]);
  }

  factory Planet.lab10() {
    return Planet(PlanetType.cold, [
      WorkerSlot({WorkerType.lab}, type: WorkerType.lab),
    ]);
  }

  factory Planet.lab01() {
    return Planet(PlanetType.cold, [
      WorkerSlot({WorkerType.lab}, type: WorkerType.lab, isAdvanced: true),
    ]);
  }

  factory Planet.gas10() {
    return Planet(PlanetType.gas, [
      WorkerSlot({WorkerType.economy, WorkerType.mining, WorkerType.lab}),
    ]);
  }

  factory Planet.gas01() {
    return Planet(PlanetType.gas, [
      WorkerSlot({WorkerType.economy, WorkerType.mining, WorkerType.lab},
          isAdvanced: true),
    ]);
  }

  factory Planet.orbital() {
    return Planet(PlanetType.orbital, [
      WorkerSlot({WorkerType.economy, WorkerType.lab}),
    ]);
  }
}
