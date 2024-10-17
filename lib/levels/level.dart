import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:ocean_survival/actors/player.dart';

class Level extends World {
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    //TODO: Create a very simple level in tiled and save it in the assets folder
    level = await TiledComponent.load('level-01.tmx', Vector2.all(16.0));

    add(level);
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('spawnPoints');
    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.type) {
        case 'player':
          add(Player(position: Vector2(spawnPoint.x, spawnPoint.y), character: 'ninja_frog'));
          break;
        default:
          break;
      }
    }
    return super.onLoad();
  }
}
