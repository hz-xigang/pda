import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';

class TagDetailState extends ChangeNotifier {
  final Set<String> _selectedTagKeys = <String>{};

  Set<String> get selectedTagKeys => _selectedTagKeys;

  String buildTagKey(ProdTag tag, int index) {
    if (tag.id?.isNotEmpty ?? false) {
      return 'id:${tag.id}';
    }
    if (tag.tagNo?.isNotEmpty ?? false) {
      return 'tag:${tag.tagNo}';
    }
    return 'index:$index:${tag.prodNo}:${tag.qty}';
  }

  bool isSelected(String tagKey) {
    return _selectedTagKeys.contains(tagKey);
  }

  void toggleSelect(String tagKey) {
    if (_selectedTagKeys.contains(tagKey)) {
      _selectedTagKeys.remove(tagKey);
    } else {
      _selectedTagKeys.add(tagKey);
    }
    notifyListeners();
  }

  List<ProdTag> selectedTags(List<ProdTag> currentTags) {
    final List<ProdTag> result = <ProdTag>[];
    for (int index = 0; index < currentTags.length; index++) {
      final ProdTag tag = currentTags[index];
      if (_selectedTagKeys.contains(buildTagKey(tag, index))) {
        result.add(tag);
      }
    }
    return result;
  }

  void clearSelection() {
    if (_selectedTagKeys.isEmpty) {
      return;
    }
    _selectedTagKeys.clear();
    notifyListeners();
  }
}

class TagDetailScope extends InheritedNotifier<TagDetailState> {
  const TagDetailScope({
    super.key,
    required TagDetailState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static TagDetailState watch(BuildContext context) {
    final TagDetailScope? scope =
        context.dependOnInheritedWidgetOfExactType<TagDetailScope>();
    assert(scope != null, 'TagDetailScope not found in context.');
    return scope!.notifier!;
  }

  static TagDetailState read(BuildContext context) {
    final InheritedElement? element =
        context.getElementForInheritedWidgetOfExactType<TagDetailScope>();
    final TagDetailScope? scope = element?.widget as TagDetailScope?;
    assert(scope != null, 'TagDetailScope not found in context.');
    return scope!.notifier!;
  }
}
