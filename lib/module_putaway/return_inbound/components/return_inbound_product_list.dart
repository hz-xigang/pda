import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/tag_item/index.dart';
import 'package:hz_xg_pda/components/workflow/product_list_view.dart';
import 'package:hz_xg_pda/module_putaway/return_inbound/state/return_inbound_state.dart';

class ReturnInboundProductList extends StatelessWidget {
  const ReturnInboundProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ReturnInboundScope.watch(context);

    return ProductListView(
      products: state.products,
      title: '已扫描产品',
      emptyText: '暂无已扫描产品',
      accentColor: const Color(0xFFFF4D5E),
      iconBackgroundColor: const Color(0xFFFFEDF0),
      onTapItem: (item) {
        final returnInboundState = ReturnInboundScope.read(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReturnInboundScope(
              notifier: returnInboundState,
              child: TagDetailPage(
                productItem: item,
                loadTags: () => returnInboundState.scannedTags
                    .where(
                      (tag) =>
                          (tag.prodOrderId ?? 'unknown_po') == item.prodOrderId,
                    )
                    .toList(growable: false),
                onDeleteSelected: returnInboundState.removeTags,
                onDeleteAll: returnInboundState.removeProductGroup,
                themeColor: const Color(0xFFFF4D5E),
                refreshListenable: returnInboundState,
              ),
            ),
          ),
        );
      },
    );
  }
}
