class DocumentOperationDocumentOption {
  const DocumentOperationDocumentOption({
    required this.id,
    required this.no,
  });

  final String id;
  final String no;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is DocumentOperationDocumentOption &&
        other.id == id &&
        other.no == no;
  }

  @override
  int get hashCode => Object.hash(id, no);
}
