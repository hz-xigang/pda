import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/tag_item/index.dart';
import 'package:hz_xg_pda/components/workflow/product_list_view.dart';
import 'package:hz_xg_pda/module_putaway/move/state/move_state.dart';

class MoveProductList extends StatelessWidget {
  const MoveProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MoveScope.watch(context);

    return ProductListView(
      products: state.products,
      title: '已扫描产品',
      emptyText: '暂无已扫描产品',
      accentColor: const Color(0xFF00B894),
      iconBackgroundColor: const Color(0xFFE3FBF5),
      onTapItem: (item) {
        final moveState = MoveScope.read(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoveScope(
              notifier: moveState,
              child: TagDetailPage(
                productItem: item,
                loadTags: () => moveState.scannedTags
                    .where(
                      (tag) =>
                          (tag.prodOrderId ?? 'unknown_po') == item.prodOrderId,
                    )
                    .toList(growable: false),
                onDeleteSelected: moveState.removeTags,
                onDeleteAll: moveState.removeProductGroup,
                themeColor: const Color(0xFF00B894),
              ),
            ),
          ),
        );
      },
    );
  }
}
