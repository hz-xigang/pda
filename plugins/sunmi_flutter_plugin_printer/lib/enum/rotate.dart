enum Rotate {
  ROTATE_0,
  ROTATE_90,
  ROTATE_180,
  ROTATE_270;

  static Rotate find(String name) {
    return Rotate.values.firstWhere((rotate) => rotate.name == name,
        orElse: () => Rotate.ROTATE_0);
  }
}
