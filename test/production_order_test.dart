import 'package:flutter_test/flutter_test.dart';
import 'package:hz_xg_pda/entity/production_order.dart';

void main() {
  test('parses a single production order from json string', () {
    const String jsonString = '''
    {
      "id": "1",
      "prodNo": "SC20260429001",
      "erpOrderNo": "PO-8823-KL",
      "inventoryCode": "INV-20240056",
      "inventoryName": "Bearing Assembly",
      "customerCode": "CUST-001",
      "productCategory": "成品",
      "spec": "BRG-6205-2RS",
      "status": 1,
      "deleted": false,
      "createTime": "2026-06-04T09:30:00",
      "m1": "remark1",
      "m2": "remark2",
      "m3": "remark3",
      "m4": "remark4",
      "m5": "remark5",
      "type": "2"
    }
    ''';

    final ProductionOrder order = ProductionOrder.fromJsonString(jsonString);

    expect(order.id, '1');
    expect(order.prodNo, 'SC20260429001');
    expect(order.status, isTrue);
    expect(order.deleted, isFalse);
    expect(order.type, 2);
    expect(order.createTime, DateTime.parse('2026-06-04T09:30:00'));
  });

  test('parses a production order list from json string', () {
    const String jsonString = '''
    [
      {
        "id": "1",
        "prodNo": "SC20260429001",
        "status": 1
      },
      {
        "id": "2",
        "prodNo": "SC20260429002",
        "status": 0
      }
    ]
    ''';

    final List<ProductionOrder> orders =
        ProductionOrder.listFromJsonString(jsonString);

    expect(orders.length, 2);
    expect(orders.first.prodNo, 'SC20260429001');
    expect(orders.first.status, isTrue);
    expect(orders.last.prodNo, 'SC20260429002');
    expect(orders.last.status, isFalse);
  });
}
