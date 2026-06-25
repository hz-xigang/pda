import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';

class CartonLabelCard extends StatelessWidget {
  const CartonLabelCard({
    super.key,
    required this.item,
  });

  final ProdTag item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
        children: [
          _InfoRow(label: '条码号', value: item.tagNo ?? '--'),
          _InfoRow(label: '生产单号', value: item.prodNo ?? '--'),
          _InfoRow(label: '数量', value: _formatNumber(item.qty)),
          _InfoRow(label: '毛重(kg)', value: _formatNumber(item.grossWeight)),
          _InfoRow(label: '净重(kg)', value: _formatNumber(item.netWeight)),
          _InfoRow(
            label: '产品类别',
            value: item.productCategory ?? '--',
            isLast: true,
          ),
        ],
      ),
    );
  }

  static String _formatNumber(double? value) {
    if (value == null) {
      return '--';
    }
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF111827),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
