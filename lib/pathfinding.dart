import 'package:collection/collection.dart';

import "cell.dart";

typedef Edges = Map<Cell, Map<Cell, int>>;

class _CellItem {
  final Cell cell;
  final int priority;

  _CellItem(this.cell, this.priority);
}

class Pathfinding {
  final Edges edges;

  Pathfinding(this.edges);

  Map<Cell, List<Cell>> findAllPath(Cell originalNode, int movementPoint) {
    final playerNumber = originalNode.ship?.state.playerNumber ?? -1;
    final frontier = HeapPriorityQueue<_CellItem>((_CellItem itemA, _CellItem itemB) {
      return itemA.priority - itemB.priority;
    });
    frontier.add(_CellItem(originalNode, 0));

    final Map<Cell, Cell> cameFrom = {
      originalNode: originalNode,
    };
    final Map<Cell, int> costSoFar = {
      originalNode: 0,
    };

    while (frontier.isNotEmpty) {
      final current = frontier.removeFirst();
      final neighbours = _getNeighbours(current.cell);
      for (final neighbour in neighbours) {
        final newCost =
            costSoFar[current.cell]! + edges[current.cell]![neighbour]!;
        // Hostile ship or planet
        if (neighbour.ship != null &&
            neighbour.ship!.state.playerNumber != playerNumber) {
          continue;
        }
        if (neighbour.planet != null &&
            neighbour.planet!.attackable(playerNumber)) {
          continue;
        }
        if (newCost > movementPoint) {
          continue;
        }
        if (!costSoFar.containsKey(neighbour) ||
            (newCost < costSoFar[neighbour]!)) {
          costSoFar[neighbour] = newCost;
          cameFrom[neighbour] = current.cell;
          frontier.add(_CellItem(neighbour, newCost));
        }
      }
    }

    final Map<Cell, List<Cell>> paths = {};
    for (final destination in cameFrom.keys) {
      final List<Cell> path = [];
      Cell current = destination;
      // Cell is occupied by other ship
      if (current.ship != null) {
        continue;
      }
      while (current != originalNode) {
        path.add(current);
        current = cameFrom[current]!;
      }

      paths[destination] = path;
    }

    return paths;
  }

  Iterable<Cell> _getNeighbours(Cell node) {
    if (!edges.containsKey(node)) {
      return const [];
    }

    final map = edges[node]!;

    return map.keys;
  }
}
