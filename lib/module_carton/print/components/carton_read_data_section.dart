import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/section_title.dart';
import 'package:hz_xg_pda/entity/production_order.dart';

class CartonReadDataSection extends StatelessWidget {
  const CartonReadDataSection({
    super.key,
    required this.productionOrder,
  });

  final ProductionOrder productionOrder;

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, String>> items = [
      MapEntry('生产单号', _displayValue(productionOrder.prodNo)),
      MapEntry('产品类别', _displayValue(productionOrder.productCategory)),
      MapEntry('客户订单号', _displayValue(productionOrder.erpOrderNo)),
      MapEntry('客户料号', _displayValue(productionOrder.customerCode)),
      MapEntry('存货名称', _displayValue(productionOrder.inventoryName)),
      MapEntry('规格型号', _displayValue(productionOrder.spec)),
      MapEntry('存货编码', _displayValue(productionOrder.inventoryCode)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: '系统读取数据'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 90,
                          child: Text(
                            item.key,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF4B5563),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F8FB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                item.value,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0F274D),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  String _displayValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '--';
    }
    return value;
  }
}
