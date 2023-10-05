import "edges.dart";
import "cell.dart";

class _PriorityQueue<T> {
  final T item;
  final int priority;

  _PriorityQueue(this.item, this.priority);
}

class _HeapPriorityQueue<T> {
  final List<_PriorityQueue<T>> _queue = List.empty(growable: true);

  int get count => _queue.length;

  enqueue(T item, int priority) {
    _queue.add(_PriorityQueue<T>(item, priority));

    int ci = count - 1;
    while (ci > 0) {
      final pi = (ci - 1) ~/ 2;
      if (_queue[ci].priority > _queue[pi].priority) {
        break;
      }

      final tmp = _queue[ci];
      _queue[ci] = _queue[pi];
      _queue[pi] = tmp;
      ci = pi;
    }
  }

  _PriorityQueue<T> dequeue() {
    return _queue.removeAt(0);
  }
}

class Pathfinding {
  final Edges edges;

  Pathfinding(this.edges);

  Map<Cell, List<Cell>> findAllPath(Cell originalNode, int movementPoint) {
    final frontier = _HeapPriorityQueue<Cell>();
    frontier.enqueue(originalNode, 0);

    final Map<Cell, Cell> cameFrom = {
      originalNode: originalNode,
    };
    final Map<Cell, int> costSoFar = {
      originalNode: 0,
    };

    while (frontier.count != 0) {
      final current = frontier.dequeue();
      final neighbours = _getNeighbours(current.item);
      for (final neighbour in neighbours) {
        final newCost = costSoFar[current.item]! + edges[current.item]![neighbour]!;
        if (newCost > movementPoint) {
          continue;
        }
        if (!costSoFar.containsKey(neighbour) || (newCost < costSoFar[neighbour]!)) {
          costSoFar[neighbour] = newCost;
          cameFrom[neighbour] = current.item;
          frontier.enqueue(neighbour, newCost);
        }
      }
    }

    final Map<Cell, List<Cell>> paths = {};
    for (final destination in cameFrom.keys) {
      final List<Cell> path = List.empty(growable: true);
      Cell current = destination;
      while (current != originalNode) {
        path.add(current);
        current = cameFrom[current]!;
      }

      paths[destination] = path;
    }

    return paths;
  }

  List<Cell> _getNeighbours (Cell node) {
    if (!edges.containsKey(node)) {
      return [];
    }

    final map = edges[node]!;

    return map.keys.toList();
  }
}
