import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
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
      //position: Vector2(hitboxOffsetX, hitboxOffsetY),
      size: Vector2.all(32),
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
    if (intersectionPoints.length == 2) {
      var pointA = intersectionPoints.elementAt(0);
      var pointB = intersectionPoints.elementAt(1);
      final mid = (pointA + pointB) / 2;
      final collisionVector = absoluteCenter - mid;
      if (pointA.x == pointB.x || pointA.y == pointB.y) {
        // Hitting a side without touching a corner
        double penetrationDepth = (size.x / 2) - collisionVector.length;
        collisionVector.normalize();
        position += collisionVector.scaled(penetrationDepth);
      } else {
        position += _cornerBumpDistance(collisionVector, pointA, pointB);
      }
    }
  }

  Vector2 _cornerBumpDistance(
      Vector2 directionVector, Vector2 pointA, Vector2 pointB) {
    var dX = (pointA.x - size.x) - pointB.x;
    var dY = pointA.y - pointB.y;
    // The order of the two intersection points differs per corner
    // The following if statements negates the necessary values to make the
    // player move back to the right position
    if (directionVector.x > 0 && directionVector.y < 0) {
      // Top right corner
      dX = -dX;
    } else if (directionVector.x > 0 && directionVector.y > 0) {
      // Bottom right corner
      dX = -dX;
    } else if (directionVector.x < 0 && directionVector.y > 0) {
      // Bottom left corner
      dY = -dY;
    } else if (directionVector.x < 0 && directionVector.y < 0) {
      // Top left corner
      dY = -dY;
    }
    // The absolute smallest of both values determines from which side the player bumps
    // and therefor determines the needed displacement
    if (dX.abs() < dY.abs()) {
      return Vector2(dX, 0);
    } else {
      return Vector2(0, dY);
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
