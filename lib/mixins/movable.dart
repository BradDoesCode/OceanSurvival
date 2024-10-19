import 'package:flame/components.dart';

mixin Movable on PositionComponent {
  double speed = 100;
  double jump = -100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  double terminalVelocity = 100;
  double gravity = 9.8;
  bool isOnGround = true;

  void move(Vector2 delta, double dt) {
    velocity.x = delta.x * (speed * dt);
    if (isOnGround) {
      velocity.y = delta.y * (speed * dt);
    } else {
      _applyGravity(dt);
    }
    position.add(velocity * dt);
    _flip(delta.x);
  }

  void _flip(double deltaX) {
    if (deltaX < 0 && isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = false;
    } else if (deltaX > 0 && !isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = true;
    }
  }

  void _applyGravity(double dt) {
    velocity.y += gravity * dt;
    velocity.y = velocity.y.clamp(-terminalVelocity, terminalVelocity);
    position.y += velocity.y * dt;
  }

  void setVelocity(Vector2 newVelocity) {
    velocity = newVelocity;
  }

  void updatePosition(double dt) {
    if (!isOnGround) {
      _applyGravity(dt);
    }
    position.add(velocity * dt);
  }
}
