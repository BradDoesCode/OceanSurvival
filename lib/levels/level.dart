import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:ocean_survival/actors/player.dart';

class Level extends World {
  late TiledComponent level;
  Level({required this.name});
  final String name;
  @override
  FutureOr<void> onLoad() async {
    //TODO: Create a very simple level in tiled and save it in the assets folder
    level = await TiledComponent.load(name, Vector2.all(16.0));

    add(level);
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('spawnPoints');
    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.type) {
        case 'Player':
          add(Player(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              character: 'ninja_frog'));
          break;
        default:
          break;
      }
    }
    return super.onLoad();
  }
}
