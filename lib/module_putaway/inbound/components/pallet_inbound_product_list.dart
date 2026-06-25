import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/product_list_view.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';

class PalletInboundProductList extends StatelessWidget {
  const PalletInboundProductList({
    super.key,
    required this.products,
  });

  final List<PalletProductItem> products;

  @override
  Widget build(BuildContext context) {
    return ProductListView(
      products: products,
      title: '已扫描产品',
      emptyText: '暂无已扫描产品',
      accentColor: const Color(0xFF18A8F1),
      iconBackgroundColor: const Color(0xFFE5F7FF),
    );
  }
}
