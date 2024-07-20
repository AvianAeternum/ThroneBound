import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:thronebound/world/world.dart';

class ThroneboundGame extends FlameGame<ThroneboundWorld> with KeyboardEvents {
  ThroneboundGame() : super(world: ThroneboundWorld());

  @override
  Future<void> onLoad() async {}

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    return KeyEventResult.ignored;
  }
}
