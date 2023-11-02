import '../../presentation_layer/fps_counter.dart';

// Fps Singleton that is to show the fps on the screen
class FPSSingleton {
  // singleton instance
  static final FPSSingleton _singleton = FPSSingleton._internal();

  // fps counter
  static FPSCounter counter = FPSCounter();

  // contructor that returns the instance
  factory FPSSingleton() => _singleton;

  // internal constructor
  FPSSingleton._internal();

  get fps => counter.fps;

  void update() {
    counter.update(DateTime.now().millisecondsSinceEpoch);
  }
}
