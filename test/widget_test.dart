import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hz_xg_pda/entity/production_order.dart';
import 'package:hz_xg_pda/main.dart';
import 'package:hz_xg_pda/module_carton/print/index.dart';

void main() {
  testWidgets('renders home page by default and navigates to mine page', (
    tester,
  ) async {
    await tester.pumpWidget(const WarehouseApp());

    expect(find.text('仓储作业'), findsOneWidget);
    expect(find.text('纸箱标签打印'), findsOneWidget);

    await tester.tap(find.text('我的'));
    await tester.pumpAndSettle();

    expect(find.text('我的'), findsWidgets);
  });

  testWidgets('navigates to carton label print page from home card', (
    tester,
  ) async {
    await tester.pumpWidget(const WarehouseApp());

    await tester.tap(find.text('纸箱标签打印'));
    await tester.pumpAndSettle();

    expect(find.text('请扫码生产单号'), findsOneWidget);
    expect(find.text('打印'), findsOneWidget);
  });

  testWidgets('shows sections when production order is provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CartonLabelPrintPage(
          productionOrder: const ProductionOrder(
            prodNo: 'SC20260429001',
            productCategory: '成品',
            erpOrderNo: 'PO-8823-KL',
            customerCode: 'CUST-PN-5621',
            inventoryName: '精密轴承组件',
            spec: 'BRG-6205-2RS',
            inventoryCode: 'INV-20240056',
          ),
        ),
      ),
    );

    expect(find.text('系统读取数据'), findsOneWidget);
    expect(find.text('手动输入信息'), findsOneWidget);
    expect(find.text('请扫码生产单号'), findsNothing);
    expect(find.text('SC20260429001'), findsOneWidget);
    expect(find.text('精密轴承组件'), findsOneWidget);
  });
}
