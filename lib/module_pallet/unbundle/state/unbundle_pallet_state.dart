import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/ApiException.dart';
import 'package:hz_xg_pda/http/PalletApi.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class UnbundlePalletState extends ChangeNotifier {
  String? _palletNo;
  List<ProdTag> _tags = <ProdTag>[];
  Set<String> _selectedTagNos = <String>{};
  bool _isLoading = false;

  String? get palletNo => _palletNo;
  List<ProdTag> get tags => _tags;
  Set<String> get selectedTagNos => _selectedTagNos;
  bool get isLoading => _isLoading;
  int get totalCount => _tags.length;
  int get selectedCount => _selectedTagNos.length;
  int get currentStep => (_palletNo == null || _tags.isEmpty) ? 1 : 2;

  void clear() {
    _palletNo = null;
    _tags = <ProdTag>[];
    _selectedTagNos = <String>{};
    notifyListeners();
  }

  Future<void> loadPallet(String barcode) async {
    final String palletNo = barcode.startsWith('3') ? barcode.substring(1) : barcode;

    _isLoading = true;
    notifyListeners();

    try {
      final List<ProdTag> tags = await PalletApi.findTagsByPallet(palletNo, 0, null);
      if (tags.isEmpty) {
        FeedbackUtil.showInfo('托盘【$palletNo】无可用标签');
        _isLoading = false;
        notifyListeners();
        return;
      }

      _palletNo = palletNo;
      _tags = tags;
      _selectedTagNos = tags.map((t) => '${t.tagNo}').toSet();
      FeedbackUtil.showSuccess('托盘【$palletNo】加载成功，共 ${tags.length} 个标签');
    } catch (e) {
      FeedbackUtil.showError('加载托盘失败：${e is ApiException ? e.message : e}');
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleTag(String tagNo) {
    if (_selectedTagNos.contains(tagNo)) {
      _selectedTagNos.remove(tagNo);
    } else {
      _selectedTagNos.add(tagNo);
    }
    notifyListeners();
  }

  void selectAll() {
    _selectedTagNos = _tags.map((t) => '${t.tagNo}').toSet();
    notifyListeners();
  }

  void deselectAll() {
    _selectedTagNos = <String>{};
    notifyListeners();
  }

  Future<void> confirmUnbundle(BuildContext context) async {
    if (_palletNo == null || _selectedTagNos.isEmpty) {
      FeedbackUtil.showInfo('请选择要拆除的标签');
      return;
    }

    final bool confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认拆托'),
        content: Text('将拆除 ${_selectedTagNos.length} 个标签，确认？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('确认'),
          ),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    FeedbackUtil.showLoading('拆托中...');
    try {
      await PalletApi.unbundle(_palletNo!, _selectedTagNos.toList());
      FeedbackUtil.showSuccess('拆托成功');

      // 从列表中移除已拆除的标签
      _tags = _tags.where((t) => !_selectedTagNos.contains('${t.tagNo}')).toList();
      _selectedTagNos = _tags.map((t) => '${t.tagNo}').toSet();

      if (_tags.isEmpty) {
        _palletNo = null;
      }
    } catch (e) {
      FeedbackUtil.showError('拆托失败：${e is ApiException ? e.message : e}');
    }
    notifyListeners();
  }
}

typedef UnbundlePalletScope = NotifierScope<UnbundlePalletState>;
