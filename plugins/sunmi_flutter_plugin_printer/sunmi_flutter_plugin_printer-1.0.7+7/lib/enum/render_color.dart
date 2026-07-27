enum RenderColor {
  BLACK,
  RED;

  static RenderColor find(String name) {
    return RenderColor.values.firstWhere((color) => color.name == name,
        orElse: () => RenderColor.BLACK);
  }
}
