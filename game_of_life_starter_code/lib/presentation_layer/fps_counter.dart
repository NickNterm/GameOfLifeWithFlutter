import '../core/singleton/fps_singleton.dart';

class FPSCounter {
  int _frames = 0;
  int _lastTime = 0;
  int _fps = 0;

  int get fps => _fps;

  void update(int time) {
    _frames++;
    if (time - _lastTime >= 1000) {
      _fps = _frames;
      _frames = 0;
      _lastTime = time;
    }
    FPSSingleton().fps = _fps;
  }
}
