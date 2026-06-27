import 'package:flutter/material.dart';
import 'package:hz_xg_pda/module_putaway/base/base_putaway_page.dart';
import 'package:hz_xg_pda/module_putaway/move/components/move_confirm_bar.dart';
import 'package:hz_xg_pda/module_putaway/move/components/move_location_section.dart';
import 'package:hz_xg_pda/module_putaway/move/components/move_product_list.dart';
import 'package:hz_xg_pda/module_putaway/move/components/move_step_indicator.dart';
import 'package:hz_xg_pda/module_putaway/move/components/move_total_count.dart';
import 'package:hz_xg_pda/module_putaway/move/state/move_state.dart';

class MovePage extends StatelessWidget {
  const MovePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePutawayPage<MoveState>(
      createNotifier: MoveState.new,
      scopeBuilder: (state, child) => MoveScope(
        notifier: state,
        child: child,
      ),
      onScan: (state, result, context) => state.onScanProduct(result, context),
      child: const BasePutawayBody(
        stepIndicator: MoveStepIndicator(),
        totalCount: MoveTotalCount(),
        productList: MoveProductList(),
        locationSection: MoveLocationSection(),
        confirmBar: MoveConfirmBar(),
      ),
    );
  }
}
