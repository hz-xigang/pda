import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/app_back_bar.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/module_pallet/print/state/pallet_state.dart';
import 'package:hz_xg_pda/module_pallet/tag_item/components/pallet_tag_detail_action_bar.dart';
import 'package:hz_xg_pda/module_pallet/tag_item/components/pallet_tag_detail_header.dart';
import 'package:hz_xg_pda/module_pallet/tag_item/components/pallet_tag_detail_list.dart';
import 'package:hz_xg_pda/module_pallet/tag_item/state/pallet_tag_detail_state.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class PalletTagDetailPage extends StatefulWidget {
  const PalletTagDetailPage({
    super.key,
    required this.productItem,
  });

  final PalletProductItem productItem;

  @override
  State<PalletTagDetailPage> createState() => _PalletTagDetailPageState();
}

class _PalletTagDetailPageState extends State<PalletTagDetailPage> {
  late final PalletTagDetailState _detailState;

  @override
  void initState() {
    super.initState();
    _detailState = PalletTagDetailState();
  }

  @override
  void dispose() {
    _detailState.dispose();
    super.dispose();
  }

  List<ProdTag> _currentTags() {
    final PalletState palletState = PalletScope.read(context);
    return palletState.scannedTags
        .where(
          (tag) =>
              (tag.prodOrderId ?? 'unknown_po') == widget.productItem.prodOrderId,
        )
        .toList(growable: false);
  }

  Future<void> _deleteSelected() async {
    final List<ProdTag> currentTags = _currentTags();
    final List<ProdTag> selectedTags = _detailState.selectedTags(currentTags);
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

    final PalletState palletState = PalletScope.read(context);
    palletState.removeTags(selectedTags);
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

    final PalletState palletState = PalletScope.read(context);
    palletState.removeProductGroup(widget.productItem.prodNo);
    _detailState.clearSelection();
  }

  @override
  Widget build(BuildContext context) {
    final PalletState palletState = PalletScope.watch(context);
    final List<ProdTag> currentTags = palletState.scannedTags
        .where(
          (tag) =>
              (tag.prodOrderId ?? 'unknown_po') == widget.productItem.prodOrderId,
        )
        .toList(growable: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: SafeArea(
        child: PalletTagDetailScope(
          notifier: _detailState,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBackBar(onTap: () => Navigator.pop(context)),
                const SizedBox(height: 16),
                const PalletTagDetailHeader(),
                const SizedBox(height: 12),
                Expanded(
                  child: PalletTagDetailList(
                    tags: currentTags,
                    spec: widget.productItem.spec,
                  ),
                ),
                const SizedBox(height: 16),
                PalletTagDetailActionBar(
                  onDeleteSelected: _deleteSelected,
                  onDeleteAll: _deleteAll,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
