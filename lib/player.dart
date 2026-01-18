import 'package:flutter/material.dart' show Color, Colors;

class Player {
  final int playerNumber;
  bool active = true;
  final bool isAI;

  Player(this.playerNumber, this.isAI, {this.color = Colors.grey});

  final Color color;

  Map<String, dynamic> toJson() {
    return {
      'playerNumber': playerNumber,
      'active': active,
      'isAI': isAI,
      'color': color.toARGB32(),
    };
  }
}
