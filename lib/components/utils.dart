import 'package:ocean_survival/components/collision_block.dart';
import 'package:ocean_survival/components/player.dart';

bool checkCollision(Player player, CollisionBlock block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final objectX = block.x;
  final objectY = block.y;
  final objectWidth = block.width;
  final objectHeight = block.height;

  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - player.width
      : playerX;
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  return (fixedY < objectY + objectHeight &&
      playerY + playerHeight > objectY &&
      fixedX < objectX + objectWidth &&
      fixedX + playerWidth > objectX);
}
