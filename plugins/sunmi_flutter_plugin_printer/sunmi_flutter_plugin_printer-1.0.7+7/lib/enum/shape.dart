enum Shape {
  RECT_FILL,
  RECT_WHITE,
  RECT_REVERSE,
  BOX,
  CIRCLE,
  OVAL,
  PATH,
}

extension ShapeExtension on Shape {
  static Shape find(String name) {
    return Shape.values.firstWhere((shape) => shape.name == name,
        orElse: () => Shape.RECT_FILL);
  }
}
