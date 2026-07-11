import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/tag_item/index.dart';
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
      onTapItem: (item) {
        final documentState = DocumentOperationScope.read(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentOperationScope(
              notifier: documentState,
              child: TagDetailPage(
                productItem: item,
                loadTags: () => documentState.scannedTags
                    .where(
                      (tag) =>
                          (tag.prodOrderId ?? 'unknown_po') == item.prodOrderId,
                    )
                    .toList(growable: false),
                onDeleteSelected: documentState.removeTags,
                onDeleteAll: documentState.removeProductGroup,
                themeColor: documentOperationAccentColor,
                refreshListenable: documentState,
              ),
            ),
          ),
        );
      },
    );
  }
}
