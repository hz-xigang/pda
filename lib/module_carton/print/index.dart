import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/app_back_bar.dart';
import 'package:hz_xg_pda/entity/production_order.dart';
import 'package:hz_xg_pda/http/ProdApi.dart';
import 'package:hz_xg_pda/provider/ProductionOrderCacheProvider.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';

import 'components/carton_manual_input_section.dart';
import 'components/carton_print_action_bar.dart';
import 'components/carton_read_data_section.dart';
import 'components/carton_scan_prompt.dart';
import 'state/carton_print_state.dart';

class CartonLabelPrintPage extends StatefulWidget {
  const CartonLabelPrintPage({
    super.key,
    this.productionOrder,
  });

  final ProductionOrder? productionOrder;

  @override
  State<CartonLabelPrintPage> createState() => _CartonLabelPrintPageState();
}

class _CartonLabelPrintPageState extends State<CartonLabelPrintPage> {
  // 定义一个订阅对象，用于页面销毁时解绑
  StreamSubscription<String>? _scanSubscription;
  late final CartonPrintState _cartonPrintState;

  @override
  void initState() {
    super.initState();
    _cartonPrintState = CartonPrintState(
      productionOrder: widget.productionOrder,
    );
    _loadCachedProductionOrder();
    _scanSubscription = PdaUtil().onScanResult.listen(scanProdNo);
  }

  @override
  void dispose() {
    // 离开页面时必须取消订阅，防止内存泄漏，同时该页面不再接收扫码
    _scanSubscription?.cancel();
    _cartonPrintState.dispose();
    super.dispose();
  }

  Future<void> _loadCachedProductionOrder() async {
    final ProductionOrder? cachedProductionOrder =
        await ProductionOrderCacheProvider.getProductionOrder();
    if (cachedProductionOrder == null) {
      return;
    }
    _cartonPrintState.setProductionOrder(cachedProductionOrder);
  }

  void scanProdNo(String prodNo) async {

    final ProductionOrder productionOrder = await ProdApi.findByPgNo(prodNo);
    _cartonPrintState.setProductionOrder(productionOrder);
    await ProductionOrderCacheProvider.saveProductionOrder(productionOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CartonPrintScope(
          notifier: _cartonPrintState,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: Column(
              children: [
                AppBackBar(
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 8),
                const Expanded(
                  child: _CartonPrintBody(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CartonPrintBody extends StatelessWidget {
  const _CartonPrintBody();

  @override
  Widget build(BuildContext context) {
    final CartonPrintState state = CartonPrintScope.watch(context);
    final ProductionOrder? productionOrder = state.productionOrder;

    return Column(
      children: [
        Expanded(
          child: productionOrder == null
              ? const CartonScanPrompt()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CartonReadDataSection(
                        productionOrder: productionOrder,
                      ),
                      const SizedBox(height: 10),
                      const CartonManualInputSection(),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 12),
        const CartonPrintActionBar(),
      ],
    );
  }
}
