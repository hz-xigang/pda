enum Align {
  DEFAULT,
  LEFT,
  CENTER,
  RIGHT;

  static Align find(String name) {
    return Align.values
        .firstWhere((align) => align.name == name, orElse: () => Align.DEFAULT);
  }
}
