import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:ocean_survival/components/collision_block.dart';
import 'package:ocean_survival/components/player.dart';

class Level extends World {
  late TiledComponent level;
  Level({required this.name, required this.player});
  final String name;
  final Player player;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(name, Vector2.all(16.0));

    add(level);
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('spawnPoints');
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.type) {
          case 'Player':
            add(player..position = spawnPoint.position);
            break;
          default:
            break;
        }
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('collisions');
    
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'platform': //lader
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block); //to see in debug mode
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
    return super.onLoad();
  }
}
