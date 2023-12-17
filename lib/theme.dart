import 'dart:ui';
import "package:flutter/painting.dart" show TextStyle;
import "package:flutter/material.dart" show Colors;
import "package:flame/game.dart";

final text16 =
    TextPaint(style: const TextStyle(color: Colors.white, fontSize: 16));

final buttonBGPaint = Paint()..color = Colors.blue;
final buttonBorderPaint = Paint()..style = PaintingStyle.stroke..color = Colors.orangeAccent..strokeWidth = 2;
