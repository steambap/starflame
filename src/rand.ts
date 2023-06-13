interface props {
  seed: number;
}

export class Rand {
  seed: number;

  constructor(rand: Rand | props | undefined) {
    if (rand == undefined) {
      this.seed = Date.now();
    } else {
      this.seed = rand.seed | 0;
    }
  }

  /** Returns a pseudorandom number between 0 and 1. */
  next() {
    this.seed = (this.seed + 0x6d2b79f5) | 0;
    let t = Math.imul(this.seed ^ (this.seed >>> 15), 1 | this.seed);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  }

  getRandomNumber(max: number) {
    return Math.floor(this.next() * max);
  }

  // Note that the max is INCLUSIVE
  getRandomNumberBetween(min: number, max: number): number {
    return Math.floor(this.next() * (max - min + 1) + min);
  }

  getRandomNumberBetweenEXP(
    min: number,
    max: number,
    P1: number = 0.5
  ): number {
    // P1 is the chance that the result is below half. So if the end result is between 0 and 1, like a Math.random,
    // P1 describes the chance of the number being between 0 and 0.5, this makes P2 the chance of it being between 0.5 and 1
    let P2 = 1 - P1;
    if (P1 <= 0) {
      return max;
    } else if (P1 >= 1) {
      return min;
    }
    let t = this.next();
    let exp = Math.log(P2) / Math.log(0.5);
    // t**exp is still a value between 0 and 1, however the odds on each range is not the same, for example, if exp = 2, the odds on t**exp > 0.5 are 75%,
    return Math.floor(t ** exp * (max - min + 1) + min);
  }

  getRandomAngle(): number {
    return this.next() * Math.PI * 2;
  }

  getRandomRadius(maxRadius: number, offset: number): number {
    return maxRadius * this.next() ** offset;
  }

  getRandomPositionInCircle(maxRadius: number, offset: number = 0.5) {
    let angle = this.getRandomAngle();
    let radius = this.getRandomRadius(maxRadius, offset);

    return {
      x: Math.cos(angle) * radius,
      y: Math.sin(angle) * radius,
    };
  }
}
