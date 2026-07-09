import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/product_list_view.dart';
import 'package:hz_xg_pda/module_document_operation/document_operation_theme.dart';
import 'package:hz_xg_pda/module_document_operation/state/document_operation_state.dart';

class DocumentOperationProductList extends StatelessWidget {
  const DocumentOperationProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = DocumentOperationScope.watch(context);

    return ProductListView(
      products: state.products,
      title: '已扫描产品',
      emptyText: '暂无已扫描产品',
      accentColor: documentOperationAccentColor,
      iconBackgroundColor: documentOperationLightColor,
    );
  }
}
