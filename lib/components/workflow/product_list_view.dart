import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({
    super.key,
    required this.products,
    required this.title,
    required this.emptyText,
    required this.accentColor,
    required this.iconBackgroundColor,
    this.onTapItem,
  });

  final List<PalletProductItem> products;
  final String title;
  final String emptyText;
  final Color accentColor;
  final Color iconBackgroundColor;
  final ValueChanged<PalletProductItem>? onTapItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        products.isEmpty
            ? _EmptyProducts(emptyText: emptyText)
            : Column(
                children: products
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ProductCard(
                          item: item,
                          accentColor: accentColor,
                          iconBackgroundColor: iconBackgroundColor,
                          onTap: onTapItem == null ? null : () => onTapItem!(item),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.item,
    required this.accentColor,
    required this.iconBackgroundColor,
    this.onTap,
  });

  final PalletProductItem item;
  final Color accentColor;
  final Color iconBackgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
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
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border(
                left: BorderSide(
                  color: accentColor,
                  width: 4,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 20,
                    color: accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '生产单号: ${item.prodNo}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9AA3B8),
                        ),
                      ),
                      Text(
                        item.spec,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9AA3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${item.count}件',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts({
    required this.emptyText,
  });

  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
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
      child: Center(
        child: Text(
          emptyText,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF9AA3B8),
          ),
        ),
      ),
    );
  }
}
