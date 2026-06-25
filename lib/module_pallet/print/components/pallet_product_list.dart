import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/product_list_view.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';
import 'package:hz_xg_pda/module_pallet/print/state/pallet_state.dart';
import 'package:hz_xg_pda/module_pallet/tag_item/index.dart';

class PalletProductList extends StatelessWidget {
  const PalletProductList({
    super.key,
    required this.products,
  });

  final List<PalletProductItem> products;

  @override
  Widget build(BuildContext context) {
    return ProductListView(
      products: products,
      title: '已添加产品',
      emptyText: '暂无已添加产品',
      accentColor: const Color(0xFF8B3DFF),
      iconBackgroundColor: const Color(0xFFF1E8FF),
      onTapItem: (item) {
        final state = PalletScope.read(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PalletScope(
              notifier: state,
              child: PalletTagDetailPage(productItem: item),
            ),
          ),
        );
      },
    );
  }
}
