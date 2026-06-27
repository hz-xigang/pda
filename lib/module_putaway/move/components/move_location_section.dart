import 'package:flutter/material.dart';
import 'package:hz_xg_pda/module_putaway/base/components/base_putaway_location_section.dart';
import 'package:hz_xg_pda/module_putaway/move/state/move_state.dart';

class MoveLocationSection extends StatelessWidget {
  const MoveLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MoveScope.watch(context);

    return BasePutawayLocationSection(
      accentColor: const Color(0xFF00B894),
      selectedLocation: state.selectedLocation,
      locationOptions: state.locationOptions,
      onChanged: state.updateLocation,
    );
  }
}
