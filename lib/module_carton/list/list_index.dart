import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/entity/production_order.dart';
import 'package:hz_xg_pda/http/ProdTagApi.dart';
import 'package:hz_xg_pda/module_carton/list/components/carton_label_card.dart';
import 'package:hz_xg_pda/module_carton/list/components/carton_label_list_action_bar.dart';
import 'package:hz_xg_pda/module_carton/list/components/carton_label_list_back_bar.dart';
import 'package:hz_xg_pda/module_carton/list/components/carton_label_list_header.dart';
import 'package:hz_xg_pda/provider/ProductionOrderCacheProvider.dart';

class CartonLabelListPage extends StatefulWidget {
  const CartonLabelListPage({super.key});

  @override
  State<CartonLabelListPage> createState() => _CartonLabelListPageState();
}

class _CartonLabelListPageState extends State<CartonLabelListPage> {
  ProductionOrder? _productionOrder;
  List<ProdTag> _items = const [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final ProductionOrder? productionOrder =
        await ProductionOrderCacheProvider.getProductionOrder();
    final String po = productionOrder?.prodNo ?? 'PO20260001';
    final List<ProdTag> items = await ProdTagApi.list(po);

    if (!mounted) {
      return;
    }

    setState(() {
      _productionOrder = productionOrder;
      _items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String prodNo = _productionOrder?.prodNo ?? '--';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          child: Column(
            children: [
              CartonLabelListBackBar(
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              CartonLabelListHeader(
                prodNo: prodNo,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return CartonLabelCard(item: _items[index]);
                  },
                ),
              ),
              const SizedBox(height: 12),
              const CartonLabelListActionBar(),
            ],
          ),
        ),
      ),
    );
  }
}
