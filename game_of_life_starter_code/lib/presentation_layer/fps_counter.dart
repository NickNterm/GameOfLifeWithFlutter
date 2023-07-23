class FPSCounter {
  // fps counter
  int _frames = 0;
  int _lastTime = 0;
  int _fps = 0;

  // fps getter
  int get fps => _fps;

  //update the fps counter
  void update(int time) {
    _frames++;
    if (time - _lastTime >= 1000) {
      _fps = _frames;
      _frames = 0;
      _lastTime = time;
    }
  }
}
