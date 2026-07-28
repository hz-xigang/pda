enum ImageAlgorithm {
  BINARIZATION,
  DITHERING,
}

extension ImageAlgorithmExtension on ImageAlgorithm {
  static ImageAlgorithm find(String name) {
    return ImageAlgorithm.values.firstWhere((algo) => algo.name == name,
        orElse: () => ImageAlgorithm.BINARIZATION);
  }
}
