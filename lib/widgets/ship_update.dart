import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import 'package:starflame/scifi_game.dart';
import 'package:starflame/ship_blueprint.dart';
import 'package:starflame/styles.dart';

class ShipUpdate extends StatefulWidget {
  const ShipUpdate(this.game, {super.key});

  static const id = 'ship_update';

  final ScifiGame game;

  @override
  State<ShipUpdate> createState() => _ShipUpdateState();
}

class _ShipUpdateState extends State<ShipUpdate> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final Iterable<ShipBlueprint> _ships;

  @override
  void initState() {
    super.initState();
    final playerState = widget.game.controller.getHumanPlayerState();
    _ships = playerState.blueprints.where((bp) => bp.active && bp.buildable);
    _tabController = TabController(length: _ships.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.dialogBackground,
      child: Column(
        children: [
          const SizedBox(
            height: navbarHeight,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TabBar(controller: _tabController, isScrollable: true, tabs: [
                for (final ship in _ships)
                  Tab(
                    text: ship.className,
                  )
              ]),
              TextButton(
                  onPressed: () {
                    widget.game.overlays.remove(ShipUpdate.id);
                  },
                  child: const Text(
                    'x',
                    style: AppTheme.label16,
                  ))
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 160,
                height: 200,
                child: TabBarView(controller: _tabController, children: [
                  for (final ship in _ships)
                    Container(
                      color: AppTheme.cardColor,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Health:', style: AppTheme.label16),
                              Text('${ship.maxHealth()}',
                                  style: AppTheme.label16),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Movement:', style: AppTheme.label16),
                              Text('${ship.movement()}',
                                  style: AppTheme.label16),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Initiative:', style: AppTheme.label16),
                              Text('${ship.initiative()}', style: AppTheme.label16),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Cost:', style: AppTheme.label16),
                              Text('${ship.cost}', style: AppTheme.label16),
                            ],
                          ),
                        ],
                      ),
                    ),
                ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}
