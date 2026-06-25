import 'package:hz_xg_pda/entity/prod_tag.dart';

class PalletProductItem {
  const PalletProductItem({
    required this.prodOrderId,
    required this.name,
    required this.prodNo,
    required this.spec,
    required this.count,
    required this.tags,
  });

  final String prodOrderId;
  final String name;
  final String prodNo;
  final String spec;
  final int count;
  final List<ProdTag> tags;
}
