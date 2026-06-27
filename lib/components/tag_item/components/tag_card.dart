import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';

class TagCard extends StatelessWidget {
  const TagCard({
    super.key,
    required this.tag,
    required this.isSelected,
    required this.onTap,
    required this.themeColor,
  });

  final ProdTag tag;
  final bool isSelected;
  final VoidCallback onTap;
  final Color themeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: isSelected ? themeColor.withValues(alpha: 0.10) : Colors.white,
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
              color: isSelected ? themeColor : themeColor,
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
                      color: isSelected ? themeColor : const Color(0xFF0F274D),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? themeColor : const Color(0xFF9AA3B8),
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _InfoRow(
              label: '产品名称',
              value: tag.productCategory ?? '--',
              isSelected: isSelected,
              themeColor: themeColor,
            ),
            const SizedBox(height: 6),
            _InfoRow(
              label: '规格',
              value: tag.spec ?? '--',
              isSelected: isSelected,
              themeColor: themeColor,
            ),
            const SizedBox(height: 6),
            _InfoRow(
              label: '存货编码',
              value: tag.prodNo ?? '--',
              isSelected: isSelected,
              themeColor: themeColor,
            ),
            const SizedBox(height: 6),
            _InfoRow(
              label: '数量',
              value: (tag.qty ?? 0).toString(),
              isSelected: isSelected,
              themeColor: themeColor,
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
    required this.themeColor,
  });

  final String label;
  final String value;
  final bool isSelected;
  final Color themeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? themeColor : const Color(0xFF6B7280),
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
