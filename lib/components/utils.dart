import 'package:ocean_survival/components/collision_block.dart';
import 'package:ocean_survival/components/player.dart';

bool checkCollision(Player player, CollisionBlock block) {
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.width;
  final playerHeight = player.height;

  final objectX = block.x;
  final objectY = block.y;
  final objectWidth = block.width;
  final objectHeight = block.height;

  final fixedX = player.scale.x < 0 ? playerX - player.width : playerX;
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;
  return (fixedY < objectY + objectHeight &&
      playerY + playerHeight > objectY &&
      fixedX < objectX + objectWidth &&
      fixedX + playerWidth > objectX);
}
