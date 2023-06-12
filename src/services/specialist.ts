import { Specialist } from "../types/specialist";
import specialists from "../data/specialists.json";

const carrierSp = specialists.carrier as Specialist[];
const starSp = specialists.star as Specialist[];

const SpecialistService = {
  getByIdCarrier(id: number | null) {
    if (!id) {
      return null;
    }

    return carrierSp.find((x) => x.id === id);
  },
  getByIdStar(id: number | null) {
    if (!id) {
      return null;
    }

    return starSp.find((x) => x.id === id);
  },
};

export default SpecialistService;
