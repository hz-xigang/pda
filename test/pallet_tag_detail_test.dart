import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/module_pallet/print/state/pallet_state.dart';
import 'package:hz_xg_pda/module_pallet/tag_item/index.dart';

void main() {
  testWidgets('deletes only the selected 25-count barcode', (tester) async {
    final ProdTag tag174 = ProdTag(
      id: 'tag-174',
      tagNo: 'TAG-174',
      prodOrderId: 'po-1',
      prodNo: 'PO-1',
      productCategory: '产品A',
      qty: 174,
    );
    final ProdTag tag25 = ProdTag(
      id: 'tag-25',
      tagNo: 'TAG-25',
      prodOrderId: 'po-1',
      prodNo: 'PO-1',
      productCategory: '产品A',
      qty: 25,
    );
    final PalletState state = PalletState(
      initialScannedTags: <ProdTag>[tag174, tag25],
      useCache: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: PalletScope(
          notifier: state,
          child: PalletTagDetailPage(
            productItem: PalletProductItem(
              name: '产品A',
              prodNo: 'PO-1',
              spec: '规格A',
              count: 199,
              tags: <ProdTag>[tag174, tag25],
              prodOrderId: ""
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('TAG-25'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();

    expect(state.scannedTags.map((tag) => tag.id), <String?>['tag-174']);
    expect(state.totalCount, 174);
  });

  testWidgets('deletes only the selected 174-count barcode', (tester) async {
    final ProdTag tag174 = ProdTag(
      id: 'tag-174',
      tagNo: 'TAG-174',
      prodOrderId: 'po-1',
      prodNo: 'PO-1',
      productCategory: '产品A',
      qty: 174,
    );
    final ProdTag tag25 = ProdTag(
      id: 'tag-25',
      tagNo: 'TAG-25',
      prodOrderId: 'po-1',
      prodNo: 'PO-1',
      productCategory: '产品A',
      qty: 25,
    );
    final PalletState state = PalletState(
      initialScannedTags: <ProdTag>[tag174, tag25],
      useCache: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: PalletScope(
          notifier: state,
          child: PalletTagDetailPage(
            productItem: PalletProductItem(
              name: '产品A',
              prodNo: 'PO-1',
              spec: '规格A',
              count: 199,
              tags: <ProdTag>[tag174, tag25], prodOrderId: '',
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('TAG-174'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();

    expect(state.scannedTags.map((tag) => tag.id), <String?>['tag-25']);
    expect(state.totalCount, 25);
  });
}
