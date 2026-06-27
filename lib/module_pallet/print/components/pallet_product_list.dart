import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/tag_item/index.dart';
import 'package:hz_xg_pda/components/workflow/product_list_view.dart';
import 'package:hz_xg_pda/module_pallet/print/state/pallet_state.dart';

class PalletProductList extends StatelessWidget {
  const PalletProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = PalletScope.watch(context);

    return ProductListView(
      products: state.products,
      title: '已添加产品',
      emptyText: '暂无已添加产品',
      accentColor: const Color(0xFF8B3DFF),
      iconBackgroundColor: const Color(0xFFF1E8FF),
      onTapItem: (item) {
        final palletState = PalletScope.read(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PalletScope(
              notifier: palletState,
              child: TagDetailPage(
                productItem: item,
                loadTags: () => palletState.scannedTags
                    .where(
                      (tag) =>
                          (tag.prodOrderId ?? 'unknown_po') == item.prodOrderId,
                    )
                    .toList(growable: false),
                onDeleteSelected: palletState.removeTags,
                onDeleteAll: palletState.removeProductGroup,
                themeColor: const Color(0xFF8B3DFF),
              ),
            ),
          ),
        );
      },
    );
  }
}
