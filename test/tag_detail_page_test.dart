import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hz_xg_pda/components/tag_item/index.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';

void main() {
  testWidgets('updates current detail page immediately after deleting selected tags', (
    tester,
  ) async {
    final List<ProdTag> tags = <ProdTag>[
      const ProdTag(
        id: 'tag-174',
        tagNo: 'TAG-174',
        prodOrderId: 'po-1',
        prodNo: 'PO-1',
        productCategory: '产品A',
        qty: 174,
      ),
      const ProdTag(
        id: 'tag-25',
        tagNo: 'TAG-25',
        prodOrderId: 'po-1',
        prodNo: 'PO-1',
        productCategory: '产品A',
        qty: 25,
      ),
    ];

    Future<void> onDeleteSelected(List<ProdTag> selectedTags) async {
      tags.removeWhere(
        (tag) => selectedTags.any((selected) => selected.id == tag.id),
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        home: TagDetailPage(
          productItem: PalletProductItem(
            prodOrderId: 'po-1',
            name: '产品A',
            prodNo: 'PO-1',
            spec: '规格A',
            count: 199,
            tags: const <ProdTag>[],
          ),
          loadTags: () => List<ProdTag>.from(tags),
          onDeleteSelected: onDeleteSelected,
          onDeleteAll: (prodNo) async {
            tags.removeWhere((tag) => tag.prodNo == prodNo);
          },
        ),
      ),
    );

    expect(find.text('TAG-174'), findsOneWidget);
    expect(find.text('TAG-25'), findsOneWidget);

    await tester.tap(find.text('TAG-25'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();

    expect(find.text('TAG-174'), findsOneWidget);
    expect(find.text('TAG-25'), findsNothing);
  });

  testWidgets('updates current detail page immediately after deleting all tags', (
    tester,
  ) async {
    final List<ProdTag> tags = <ProdTag>[
      const ProdTag(
        id: 'tag-174',
        tagNo: 'TAG-174',
        prodOrderId: 'po-1',
        prodNo: 'PO-1',
        productCategory: '产品A',
        qty: 174,
      ),
      const ProdTag(
        id: 'tag-25',
        tagNo: 'TAG-25',
        prodOrderId: 'po-1',
        prodNo: 'PO-1',
        productCategory: '产品A',
        qty: 25,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: TagDetailPage(
          productItem: PalletProductItem(
            prodOrderId: 'po-1',
            name: '产品A',
            prodNo: 'PO-1',
            spec: '规格A',
            count: 199,
            tags: const <ProdTag>[],
          ),
          loadTags: () => List<ProdTag>.from(tags),
          onDeleteSelected: (_) async {},
          onDeleteAll: (prodNo) async {
            tags.removeWhere((tag) => tag.prodNo == prodNo);
          },
        ),
      ),
    );

    expect(find.text('TAG-174'), findsOneWidget);
    expect(find.text('TAG-25'), findsOneWidget);

    await tester.tap(find.text('删除全部'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();

    expect(find.text('TAG-174'), findsNothing);
    expect(find.text('TAG-25'), findsNothing);
    expect(find.text('暂无条码数据'), findsOneWidget);
  });
}
