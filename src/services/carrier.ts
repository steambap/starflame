import { ObjectId } from "../types/object_id";
import { Carrier } from "../types/carrier";
import { Star } from "../types/star";
import SpecialistService from "./specialist";

const CarrierService = {
  listCarriersOwnedByPlayer(carriers: Carrier[], playerId: ObjectId) {
    return carriers.filter(
      (s) => s.ownedByPlayerId && s.ownedByPlayerId === playerId
    );
  },
  createAtStar(star: Star, carriers: Carrier[], ships: number = 1): Carrier {
    if (!Math.floor(star.shipsActual!)) {
      throw new Error("Star must have at least 1 ship to build a carrier.");
    }

    // Generate a name for the new carrier based on the star name but make sure
    // this name isn't already taken by another carrier.
    let name = this.generateCarrierName(star, carriers);

    let carrier: Carrier = {
      id: crypto.randomUUID(),
      ownedByPlayerId: star.ownedByPlayerId,
      ships: ships,
      orbiting: star.id,
      location: star.location,
      name,
      waypoints: [],
      waypointsLooped: false,
      specialistId: null,
      specialistExpireTick: null,
      specialist: null,
      isGift: false,
      locationNext: null,
    };

    // Reduce the star ships by how many we have added to the carrier.
    star.shipsActual! -= ships;
    star.ships! -= ships;

    // Check to see if the carrier should be auto-assigned a specialist.
    if (star.specialistId) {
      let starSpecialist = SpecialistService.getByIdStar(star.specialistId);

      if (starSpecialist?.modifiers.special?.autoCarrierSpecialistAssign) {
        carrier.specialistId =
          starSpecialist.modifiers.special!.autoCarrierSpecialistAssign!;
        carrier.specialist =
          SpecialistService.getByIdCarrier(carrier.specialistId) || null;
      }
    }

    return carrier;
  },
  generateCarrierName(star: Star, carriers: Carrier[]) {
    let i = 1;
    let name = `${star.name} ${i++}`;

    while (carriers.find((c) => c.name == name)) {
      name = `${star.name} ${i++}`;
    }

    return name;
  },
};

export default CarrierService;
