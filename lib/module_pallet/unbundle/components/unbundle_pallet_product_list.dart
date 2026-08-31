import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/module_pallet/unbundle/state/unbundle_pallet_state.dart';

class UnbundlePalletProductList extends StatelessWidget {
  const UnbundlePalletProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NotifierScope.watch<UnbundlePalletState>(context);
    final tags = state.tags;
    final selectedTagNos = state.selectedTagNos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: const Color(0xFFE86B3C),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '托盘内标签',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: state.selectAll,
              child: const Text(
                '全选',
                style: TextStyle(
                  color: Color(0xFFE86B3C),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: state.deselectAll,
              child: const Text(
                '取消全选',
                style: TextStyle(
                  color: Color(0xFF9AA3B8),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (state.palletNo == null)
          const _EmptyHint(text: '请扫描托盘条码')
        else if (tags.isEmpty)
          const _EmptyHint(text: '该托盘无可用标签')
        else
          Column(
            children: tags
                .map(
                  (tag) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _TagSelectCard(
                      tag: tag,
                      selected: selectedTagNos.contains('${tag.tagNo}'),
                      onTap: () => state.toggleTag('${tag.tagNo}'),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
      ],
    );
  }
}

class _TagSelectCard extends StatelessWidget {
  const _TagSelectCard({
    required this.tag,
    required this.selected,
    required this.onTap,
  });

  final ProdTag tag;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF0E9) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFFE86B3C) : const Color(0xFFE5EAF3),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 14,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE3D3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.qr_code_2_rounded,
                    size: 20,
                    color: Color(0xFFE86B3C),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${tag.tagNo}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${tag.productCategory ?? '--'} | ${tag.spec ?? '--'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                  '${tag.qty?.toInt() ?? 0}件',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected
                      ? const Color(0xFFE86B3C)
                      : const Color(0xFFCDD4E8),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text});

  final String text;

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
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF9AA3B8),
          ),
        ),
      ),
    );
  }
}
