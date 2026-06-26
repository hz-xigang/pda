import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';

class TagCard extends StatelessWidget {
  const TagCard({
    super.key,
    required this.tag,
    required this.spec,
    required this.isSelected,
    required this.onTap,
  });

  final ProdTag tag;
  final String spec;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF1F2) : Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(22),
            bottomRight: Radius.circular(22),
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? const Color(0xFFE54B4B)
                  : const Color(0xFF0C45EC),
              width: 5,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    tag.tagNo ?? '--',
                    style: TextStyle(
                      fontSize: 15,
                      color: isSelected
                          ? const Color(0xFFB42318)
                          : const Color(0xFF0F274D),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isSelected
                      ? const Color(0xFFE54B4B)
                      : const Color(0xFF9AA3B8),
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _InfoRow(
              label: '产品名称',
              value: tag.productCategory ?? '--',
              isSelected: isSelected,
            ),
            const SizedBox(height: 6),
            _InfoRow(
              label: '规格',
              value: spec,
              isSelected: isSelected,
            ),
            const SizedBox(height: 6),
            _InfoRow(
              label: '存货编码',
              value: tag.prodNo ?? '--',
              isSelected: isSelected,
            ),
            const SizedBox(height: 6),
            _InfoRow(
              label: '数量',
              value: (tag.qty ?? 0).toString(),
              isSelected: isSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.isSelected,
  });

  final String label;
  final String value;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected
                ? const Color(0xFFB42318)
                : const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF0F274D),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
