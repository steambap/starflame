import { Edge } from "./edges";

interface PriorityQueue {
  item: string;
  priority: number;
}

export class HeapPriorityQueue {
  queue: PriorityQueue[];

  constructor() {
    this.queue = [];
  }

  getCount() {
    return this.queue.length;
  }

  enqueue(item: string, priority: number) {
    this.queue.push({
      item,
      priority,
    });

    let ci = this.getCount() - 1;
    while (ci > 0) {
      const pi = (ci - 1) >> 1;
      if (this.queue[ci].priority > this.queue[pi].priority) {
        break;
      }
      const tmp = this.queue[ci];
      this.queue[ci] = this.queue[pi];
      this.queue[pi] = tmp;
      ci = pi;
    }
  }

  dequeue() {
    return this.queue.shift();
  }
}

export function getNeighbour(edges: Edge, node: string): string[] {
  for (let key in edges) {
    if (key === node) {
      return Object.keys(edges[key]);
    }
  }

  return [];
}

export function findAllPath(
  edges: Edge,
  originNode: string
): Record<string, string[]> {
  const frontier = new HeapPriorityQueue();
  frontier.enqueue(originNode, 0);

  const cameFrom: Record<string, string> = {
    [originNode]: "",
  };
  const costSoFar: Record<string, number> = {
    [originNode]: 0,
  };

  while (frontier.getCount() != 0) {
    const current: PriorityQueue = frontier.dequeue()!;
    const neighbours = getNeighbour(edges, current.item);
    neighbours.forEach((neighbour) => {
      const newCost = costSoFar[current.item] + edges[current.item][neighbour];
      if (newCost > 2) {
        return;
      }
      if (!costSoFar[neighbour] || newCost < costSoFar[neighbour]) {
        costSoFar[neighbour] = newCost;
        cameFrom[neighbour] = current.item;
        frontier.enqueue(neighbour, newCost);
      }
    });
  }

  const paths: Record<string, string[]> = {};
  Object.keys(cameFrom).forEach((destination) => {
    const path: string[] = [];
    let current = destination;
    while (current !== originNode) {
      path.push(current);
      current = cameFrom[current];
    }

    paths[destination] = path;
  });

  return paths;
}
