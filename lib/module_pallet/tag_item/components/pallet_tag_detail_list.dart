import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/module_pallet/tag_item/components/pallet_tag_card.dart';
import 'package:hz_xg_pda/module_pallet/tag_item/state/pallet_tag_detail_state.dart';

class PalletTagDetailList extends StatelessWidget {
  const PalletTagDetailList({
    super.key,
    required this.tags,
    required this.spec,
  });

  final List<ProdTag> tags;
  final String spec;

  @override
  Widget build(BuildContext context) {
    final detailState = PalletTagDetailScope.watch(context);

    if (tags.isEmpty) {
      return const Center(
        child: Text(
          '暂无条码数据',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF9AA3B8),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: tags.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final tag = tags[index];
        final tagKey = detailState.buildTagKey(tag, index);

        return PalletTagCard(
          key: ValueKey<String>('pallet-tag-card-$tagKey'),
          tag: tag,
          spec: spec,
          isSelected: detailState.isSelected(tagKey),
          onTap: () => detailState.toggleSelect(tagKey),
        );
      },
    );
  }
}
