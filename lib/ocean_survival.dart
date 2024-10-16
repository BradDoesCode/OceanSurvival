import 'package:flame/components.dart';
import 'package:flame/game.dart';

class OceanSurvival extends FlameGame {
  late final CameraComponent cam;
  OceanSurvival() {
    // Add your constructor code here
  }

  @override
  Future<void> onLoad() async {
    // Load all assets here
    await images.loadAllImages();
    cam = CameraComponent.withFixedResolution(width: 1080, height: 720);
    cam.viewfinder.anchor = Anchor.topLeft;
    add(cam);
    return super.onLoad();
  }
}
