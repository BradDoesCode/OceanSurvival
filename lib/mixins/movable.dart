import 'package:flame/components.dart';

mixin Movable on PositionComponent {
  double speed = 100;
  double jump = -100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  double waterDrag = 0.95;
  double buoyancy = -5;
  bool isOnGround = true;
  Vector2? previousPosition;

  void move(Vector2 delta, double dt) {
    // Apply joystick input to velocity
    if (delta.length > 0) {
      velocity.x = delta.x * speed * dt * waterDrag;
      velocity.y = delta.y * speed * dt;
    } else {
      // Apply water drag to slow down gradually
      velocity.x *= waterDrag;
      velocity.y *= waterDrag;
    }

    // Apply buoyancy
    velocity.y += buoyancy * dt;

    // Update position based on velocity
    position.add(velocity * dt);

    // Flip character based on movement direction
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

  void updatePosition(double dt) {
    position.add(velocity * dt);
  }
}
