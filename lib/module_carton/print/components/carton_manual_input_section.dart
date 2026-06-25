import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/section_title.dart';
import '../state/carton_print_state.dart';


class CartonManualInputSection extends StatefulWidget {
  const CartonManualInputSection({super.key});

  @override
  State<CartonManualInputSection> createState() =>
      _CartonManualInputSectionState();
}

class _CartonManualInputSectionState extends State<CartonManualInputSection> {
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _grossWeightController = TextEditingController();
  final TextEditingController _netWeightController = TextEditingController();

  @override
  void dispose() {
    _qtyController.dispose();
    _grossWeightController.dispose();
    _netWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CartonPrintState state = CartonPrintScope.watch(context);

    _syncController(_qtyController, state.qtyText);
    _syncController(_grossWeightController, state.grossWeightText);
    _syncController(_netWeightController, state.netWeightText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: '手动输入信息'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _InputField(
                      label: '净重(kg)',
                      hintText: '0.00',
                      controller: _netWeightController,
                      hasError: state.netWeightError,
                      onChanged: state.updateNetWeightText,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InputField(
                      label: '毛重(kg)',
                      hintText: '0.00',
                      controller: _grossWeightController,
                      hasError: state.grossWeightError,
                      onChanged: state.updateGrossWeightText,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 206,
                  child: _InputField(
                    label: '数量',
                    hintText: '请输入数量',
                    controller: _qtyController,
                    hasError: state.qtyError,
                    onChanged: state.updateQtyText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }

    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    this.keyboardType,
    this.hasError = false,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 15,
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError ? Colors.red : const Color(0xFFD7DFEC),
                width: hasError ? 1.2 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError ? Colors.red : const Color(0xFF2E61F3),
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
