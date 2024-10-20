import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ocean_survival/components/collision_block.dart';
import 'package:ocean_survival/game/ocean_survival.dart';
import 'package:ocean_survival/mixins/movable.dart';

enum PlayerState { idle, running, falling, jumping, doubleJump, wallJump, hit }

abstract class Character extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<OceanSurvival>, Movable, CollisionCallbacks {
  final stepTime = 0.05;
  late RectangleHitbox hitbox;
  final double hitboxOffsetX = 0; // Assuming you have this defined somewhere
  final double hitboxOffsetY = 8;
  final double hitboxWidth = 16;
  final double hitboxHeight = 19;

  @override
  FutureOr<void> onLoad() {
    loadAnimations();
    hitbox = RectangleHitbox(
      position: Vector2(hitboxOffsetX, hitboxOffsetY),
      size: Vector2(hitboxWidth, hitboxHeight),
      collisionType: CollisionType.active,
    );
    add(hitbox);

    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print(intersectionPoints);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is CollisionBlock) {
      final direction = intersectionPoints.first;
      final dx = intersectionPoints.first.x - position.x + hitboxOffsetX;
      final dy = intersectionPoints.first.y - position.y;
      if (dx > dy) {
        print('Horizontal collision');
      } else {
        print('Vertical collision');
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    print('Collision end with ${other.runtimeType}');
    super.onCollisionEnd(other);
  }

  @override
  void update(double dt) {
    current = updatePlayerState();
    super.update(dt);
  }

  Future<void> loadAnimations();
  SpriteAnimation spriteAnimator(String character, String state, int amount);

  bool isMoving() {
    return (gameRef.controls.joystick?.delta.length ?? 0) > 0;
  }

  PlayerState updatePlayerState() {
    if (isMoving()) {
      return PlayerState.running;
    }
    return PlayerState.idle;
  }
}
