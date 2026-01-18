import 'dart:ui' show Paint, PaintingStyle;

import 'package:flutter/material.dart' show Color, Colors;

class Player {
  final int playerNumber;
  bool active = true;
  final bool isAI;

  Player(this.playerNumber, this.isAI, Color? color)
      : _color = color ?? Colors.grey;

  List<Paint> paintLayer = [];
  Color _color;

  Color get color => _color;

  set color(Color value) {
    _color = value;
    paintLayer = [
      Paint()..color = value.withAlpha(128),
      Paint()
        ..color = value
        ..style = PaintingStyle.stroke,
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      'playerNumber': playerNumber,
      'active': active,
      'isAI': isAI,
      'color': color.toARGB32(),
    };
  }
}
