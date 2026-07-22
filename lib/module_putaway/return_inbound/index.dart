import 'package:flutter/material.dart';
import 'package:hz_xg_pda/module_putaway/base/base_putaway_page.dart';
import 'package:hz_xg_pda/module_putaway/return_inbound/components/return_inbound_confirm_bar.dart';
import 'package:hz_xg_pda/module_putaway/return_inbound/components/return_inbound_location_section.dart';
import 'package:hz_xg_pda/module_putaway/return_inbound/components/return_inbound_product_list.dart';
import 'package:hz_xg_pda/module_putaway/return_inbound/components/return_inbound_step_indicator.dart';
import 'package:hz_xg_pda/module_putaway/return_inbound/components/return_inbound_total_count.dart';
import 'package:hz_xg_pda/module_putaway/return_inbound/state/return_inbound_state.dart';

class ReturnInboundPage extends StatelessWidget {
  const ReturnInboundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePutawayPage<ReturnInboundState>(
      createNotifier: ReturnInboundState.new,
      scopeBuilder: (state, child) => ReturnInboundScope(
        notifier: state,
        child: child,
      ),
      onScan: (state, result, context) => state.onScanProduct(result, context),
      child: const BasePutawayBody(
        stepIndicator: ReturnInboundStepIndicator(),
        totalCount: ReturnInboundTotalCount(),
        productList: ReturnInboundProductList(),
        locationSection: ReturnInboundLocationSection(),
        confirmBar: ReturnInboundConfirmBar(),
      ),
    );
  }
}
