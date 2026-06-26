import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/tag_item/index.dart';
import 'package:hz_xg_pda/components/workflow/product_list_view.dart';
import 'package:hz_xg_pda/module_putaway/inbound/state/inbound_state.dart';

class InboundProductList extends StatelessWidget {
  const InboundProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = InboundScope.watch(context);

    return ProductListView(
      products: state.products,
      title: '已扫描产品',
      emptyText: '暂无已扫描产品',
      accentColor: const Color(0xFF18A8F1),
      iconBackgroundColor: const Color(0xFFE5F7FF),
      onTapItem: (item) {
        final inboundState = InboundScope.read(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InboundScope(
              notifier: inboundState,
              child: TagDetailPage(
                productItem: item,
                loadTags: () => inboundState.scannedTags
                    .where(
                      (tag) =>
                          (tag.prodOrderId ?? 'unknown_po') == item.prodOrderId,
                    )
                    .toList(growable: false),
                onDeleteSelected: inboundState.removeTags,
                onDeleteAll: inboundState.removeProductGroup,
              ),
            ),
          ),
        );
      },
    );
  }
}
