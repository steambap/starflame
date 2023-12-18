import 'dart:ui';
import "package:flutter/painting.dart" show TextStyle;
import "package:flutter/material.dart" show Colors;
import "package:flame/game.dart";

final text16 =
    TextPaint(style: const TextStyle(color: Colors.white, fontSize: 16));
final hexPaint = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.grey.shade400;
final highlighterPaint = Paint()..color = Colors.blue.withAlpha(128);
final emptyPaint = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.transparent;
final buttonBGPaint = Paint()..color = Colors.blue.shade700;
final buttonBorderPaint = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.amber.shade400
  ..strokeWidth = 1;

final List<Paint> buttonPaintLayer = [buttonBGPaint, buttonBorderPaint];
