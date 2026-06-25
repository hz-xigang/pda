import 'package:flutter/material.dart';
import 'package:hz_xg_pda/app_routes.dart';
import '../state/carton_print_state.dart';

class CartonPrintActionBar extends StatelessWidget {
  const CartonPrintActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                final state = CartonPrintScope.read(context);
                if (state.canNavigateToList()) {
                  Navigator.pushNamed(context, AppRoutes.cartonLabelList);
                }
              },
              icon: const Icon(
                Icons.list_alt_rounded,
                size: 20,
              ),
              label: const Text(
                '标签列表',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2C55CC),
                backgroundColor: const Color(0xFFEFF3FF),
                side: const BorderSide(color: Color(0xFFB9C9FF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => CartonPrintScope.read(context).submitPrint(context),
              icon: const Icon(
                Icons.print_rounded,
                size: 20,
              ),
              label: const Text(
                '打印',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF2E61F3),
                // ⬇️ 添加这一行，缩减左右内边距
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
