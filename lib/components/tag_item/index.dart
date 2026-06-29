import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/app_back_bar.dart';
import 'package:hz_xg_pda/components/tag_item/components/tag_detail_action_bar.dart';
import 'package:hz_xg_pda/components/tag_item/components/tag_detail_header.dart';
import 'package:hz_xg_pda/components/tag_item/components/tag_detail_list.dart';
import 'package:hz_xg_pda/components/tag_item/state/tag_detail_state.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class TagDetailPage extends StatefulWidget {
  const TagDetailPage({
    super.key,
    required this.productItem,
    required this.loadTags,
    required this.onDeleteSelected,
    required this.onDeleteAll,
    required this.themeColor,
    required this.refreshListenable,
  });

  final PalletProductItem productItem;
  final List<ProdTag> Function() loadTags;
  final Future<void> Function(List<ProdTag> selectedTags) onDeleteSelected;
  final Future<void> Function(String prodNo) onDeleteAll;
  final Color themeColor;
  final Listenable refreshListenable;

  @override
  State<TagDetailPage> createState() => _TagDetailPageState();
}

class _TagDetailPageState extends State<TagDetailPage> {
  late final TagDetailState _detailState;

  @override
  void initState() {
    super.initState();
    _detailState = TagDetailState();
  }

  @override
  void dispose() {
    _detailState.dispose();
    super.dispose();
  }

  List<ProdTag> _currentTags() {
    return widget.loadTags();
  }

  Future<void> _deleteSelected() async {
    final currentTags = _currentTags();
    final selectedTags = _detailState.selectedTags(currentTags);
    if (selectedTags.isEmpty) {
      FeedbackUtil.showSnackBar(context, '请先选择要删除的条码');
      return;
    }

    final bool confirm = await DialogUtil.showConfirmDialog(
      context,
      content: '确定要删除选中的 ${selectedTags.length} 个条码吗？',
    );
    if (!confirm || !mounted) {
      return;
    }

    await widget.onDeleteSelected(selectedTags);
    _detailState.clearSelection();
  }

  Future<void> _deleteAll() async {
    final bool confirm = await DialogUtil.showConfirmDialog(
      context,
      content: '确定要删除该产品下的全部条码吗？',
    );
    if (!confirm || !mounted) {
      return;
    }

    await widget.onDeleteAll(widget.productItem.prodNo);
    _detailState.clearSelection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: SafeArea(
        child: TagDetailScope(
          notifier: _detailState,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: AnimatedBuilder(
              animation: widget.refreshListenable,
              builder: (context, child) {
                final currentTags = _currentTags();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBackBar(onTap: () => Navigator.pop(context)),
                    const SizedBox(height: 16),
                    TagDetailHeader(themeColor: widget.themeColor),
                    const SizedBox(height: 12),
                    Expanded(
                      child: TagDetailList(
                        tags: currentTags,
                        themeColor: widget.themeColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TagDetailActionBar(
                      onDeleteSelected: _deleteSelected,
                      onDeleteAll: _deleteAll,
                      themeColor: widget.themeColor,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
