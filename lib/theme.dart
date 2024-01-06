import 'dart:ui';
import "package:flutter/painting.dart" show TextStyle;
import "package:flutter/material.dart" show Colors;
import "package:flame/game.dart";

final text16 =
    TextPaint(style: const TextStyle(color: Colors.white, fontSize: 16));
final text12 =
    TextPaint(style: const TextStyle(color: Colors.white, fontSize: 12));
final hexBorderPaint = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 2
  ..color = Colors.grey.shade700;
final highlighterPaint = Paint()..color = Colors.blue.withAlpha(128);
final moveendPaint = Paint()..color = Colors.purple.withAlpha(128);
final targetPaint = Paint()..color = Colors.red.withAlpha(128);
final emptyPaint = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.transparent;
final buttonBGPaint = Paint()..color = Colors.blue.shade700;
final buttonBorderPaint = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.amber.shade400
  ..strokeWidth = 1;
final buttonBGDisabled = Paint()..color = Colors.grey.shade700;
final buttonBorderDisabled = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.grey.shade400
  ..strokeWidth = 1;

final panelBGPaint = Paint()..color = Colors.blueGrey.shade600;
final panelBorderPaint = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.grey.shade400
  ..strokeWidth = 1;

final List<Paint> buttonPaintLayer = [buttonBGPaint, buttonBorderPaint];
final List<Paint> buttonDisabledPaintLayer = [
  buttonBGDisabled,
  buttonBorderDisabled
];
final List<Paint> panelPaintLayer = [panelBGPaint, panelBorderPaint];
