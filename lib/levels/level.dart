import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:ocean_survival/actors/player.dart';

class Level extends World {
  late TiledComponent level;
  Level({required this.name, required this.player});
  final String name;
  final Player player;
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(name, Vector2.all(16.0));

    add(level);
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('spawnPoints');
    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.type) {
        case 'Player':
          add(player..position = spawnPoint.position);
          break;
        default:
          break;
      }
    }
    return super.onLoad();
  }
}
