import 'package:flutter/material.dart';

import 'package:starflame/scifi_game.dart';
import 'package:starflame/styles.dart';

Future<void> showLogDialog(ScifiGame game, BuildContext context) {
  final logs = game.aiController.logs;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('Logs: ', style: AppTheme.heading24),
        content: ListBody(
          children: logs.map((entry) {
            return Text(entry, style: AppTheme.label12);
          }).toList(),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close', style: AppTheme.label16),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
