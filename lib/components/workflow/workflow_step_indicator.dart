import 'package:flutter/material.dart';

class WorkflowStepIndicator extends StatelessWidget {
  const WorkflowStepIndicator({
    super.key,
    required this.currentStep,
    required this.activeColor,
    required this.firstLabel,
    required this.secondLabel,
  });

  final int currentStep;
  final Color activeColor;
  final String firstLabel;
  final String secondLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepItem(
          index: 1,
          label: firstLabel,
          activeColor: activeColor,
          isActive: currentStep == 1,
          isDone: currentStep > 1,
        ),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: currentStep > 1 ? activeColor : const Color(0xFFDDE3F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        _StepItem(
          index: 2,
          label: secondLabel,
          activeColor: activeColor,
          isActive: currentStep == 2,
          isDone: currentStep > 2,
        ),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.index,
    required this.label,
    required this.activeColor,
    required this.isActive,
    required this.isDone,
  });

  final int index;
  final String label;
  final Color activeColor;
  final bool isActive;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final Color circleColor =
        (isActive || isDone) ? activeColor : const Color(0xFFCDD4E8);
    final Color textColor =
        (isActive || isDone) ? activeColor : const Color(0xFF9AA3B8);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                : Text(
                    '$index',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : const Color(0xFFB0BAD0),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
