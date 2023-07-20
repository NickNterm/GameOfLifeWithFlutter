import '../../presentation_layer/fps_counter.dart';

class FPSSingleton {
  static final FPSSingleton _singleton = FPSSingleton._internal();
  static FPSCounter counter = FPSCounter();
  factory FPSSingleton() => _singleton;
  FPSSingleton._internal();

  int _fps = 0;
  int get fps => _fps;
  void update() {
    counter.update(DateTime.now().millisecondsSinceEpoch);
  }

  set fps(int value) => _fps = value;
}
