import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/tag_item/components/tag_card.dart';
import 'package:hz_xg_pda/components/tag_item/state/tag_detail_state.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';

class TagDetailList extends StatelessWidget {
  const TagDetailList({
    super.key,
    required this.tags,
    required this.spec,
  });

  final List<ProdTag> tags;
  final String spec;

  @override
  Widget build(BuildContext context) {
    final detailState = TagDetailScope.watch(context);

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

        return TagCard(
          key: ValueKey<String>('tag-card-$tagKey'),
          tag: tag,
          spec: spec,
          isSelected: detailState.isSelected(tagKey),
          onTap: () => detailState.toggleSelect(tagKey),
        );
      },
    );
  }
}
