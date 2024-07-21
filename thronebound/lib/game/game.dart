import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:thronebound/world/world.dart';

class ThroneboundGame extends FlameGame<ThroneboundWorld> with KeyboardEvents {
  // Config
  late double movementSpeed = 4;
  late double zoomSpeed = 0.1;

  // Util
  late TiledComponent mapComponent;
  late double zoom = 1;
  late double zoomVelocity = 0;
  late Vector2 cameraPosition = Vector2(0, 0);
  late Vector2 cameraVelocity = Vector2(0, 0);
  late Set<LogicalKeyboardKey> keysPressed = {};

  ThroneboundGame()
      : super(
            world: ThroneboundWorld(),
            camera: CameraComponent.withFixedResolution(
              width: 32 * 28,
              height: 32 * 14,
            ));

  @override
  Future<void> onLoad() async {
    mapComponent = await loadMap("test");
    camera.viewfinder
      ..zoom = zoom
      ..anchor = Anchor.center;
    world.add(mapComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    bool zoomIn = keysPressed.contains(LogicalKeyboardKey.equal);
    bool zoomOut = keysPressed.contains(LogicalKeyboardKey.minus);
    bool up = keysPressed.contains(LogicalKeyboardKey.keyW);
    bool left = keysPressed.contains(LogicalKeyboardKey.keyA);
    bool right = keysPressed.contains(LogicalKeyboardKey.keyD);
    bool down = keysPressed.contains(LogicalKeyboardKey.keyS);
    bool space = keysPressed.contains(LogicalKeyboardKey.space);
    cameraVelocity += Vector2(
          (right ? 1 : 0) - (left ? 1 : 0),
          (down ? 1 : 0) - (up ? 1 : 0),
        ) *
        movementSpeed;

    double magnitude = cameraVelocity.length;
    cameraPosition += cameraVelocity.normalized() * magnitude * dt;
    cameraVelocity *= 0.99;

    zoomVelocity +=
        (((zoomIn ? 0.1 : 0) - (zoomOut ? 0.1 : 0)) * zoomSpeed * 0.01)
            .clamp(-zoomSpeed, zoomSpeed);
    zoom *= (zoomVelocity + 1);
    zoom = zoom.clamp(0.15, 2);
    camera.viewfinder.zoom = zoom;
    zoomVelocity *= 0.99;
    camera.moveTo(cameraPosition);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    this.keysPressed = keysPressed;
    return KeyEventResult.ignored;
  }

  Future<TiledComponent> loadMap(String mapName) => TiledComponent.load(
      prefix: 'assets/world/map/',
      '$mapName.tmx',
      images: Images(prefix: 'assets/world/tileset/'),
      Vector2.all(32));
}
