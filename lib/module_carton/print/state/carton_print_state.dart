import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/production_order.dart';
import 'package:hz_xg_pda/http/ProdTagApi.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class CartonPrintState extends ChangeNotifier {
  CartonPrintState({
    ProductionOrder? productionOrder,
  }) : _productionOrder = productionOrder;

  ProductionOrder? _productionOrder;

  String _qtyText = '';
  String _grossWeightText = '';
  String _netWeightText = '';

  bool _qtyError = false;
  bool _grossWeightError = false;
  bool _netWeightError = false;
  bool _didAttemptSubmit = false;

  ProductionOrder? get productionOrder => _productionOrder;
  String get qtyText => _qtyText;
  String get grossWeightText => _grossWeightText;
  String get netWeightText => _netWeightText;

  bool get qtyError => _qtyError;
  bool get grossWeightError => _grossWeightError;
  bool get netWeightError => _netWeightError;

  void setProductionOrder(ProductionOrder? productionOrder) {
    final String? oldOrderKey = _productionOrder?.id ?? _productionOrder?.prodNo;
    final String? newOrderKey = productionOrder?.id ?? productionOrder?.prodNo;

    _productionOrder = productionOrder;

    if (oldOrderKey != newOrderKey) {
      _resetFormState();
    }

    notifyListeners();
  }

  void updateQtyText(String value) {
    if (_qtyText == value) {
      return;
    }
    _qtyText = value;
    if (_didAttemptSubmit) {
      _qtyError = !_isPositiveInt(value);
    }
    notifyListeners();
  }

  void updateGrossWeightText(String value) {
    if (_grossWeightText == value) {
      return;
    }
    _grossWeightText = value;
    if (_didAttemptSubmit) {
      _grossWeightError = !_isPositiveDouble(value);
    }
    notifyListeners();
  }

  void updateNetWeightText(String value) {
    if (_netWeightText == value) {
      return;
    }
    _netWeightText = value;
    if (_didAttemptSubmit) {
      _netWeightError = !_isPositiveDouble(value);
    }
    notifyListeners();
  }

  bool canNavigateToList() {
    if (_productionOrder == null) {
      FeedbackUtil.showError('请扫描生产订单号');
      return false;
    }
    return true;
  }

  Future<void> submitPrint(BuildContext context) async {
    final ProductionOrder? po = _productionOrder;
    if (po == null) {
      FeedbackUtil.showError('未扫描生产订单号');
      return;
    }

    final bool valid = _validateForm();
    if (!valid) {
      FeedbackUtil.showError('信息不能为空且必须大于 0');
      return;
    }

    final bool confirmed = await DialogUtil.showConfirmDialog(
      context,
      content: '确认提交打印吗？',
      confirmText: '确认',
    );
    if (!confirmed || !context.mounted) {
      return;
    }

    final Map<String, dynamic> res = {
      'prodOrderId': po.id,
      'grossWeight': double.parse(_grossWeightText.trim()),
      'netWeight': double.parse(_netWeightText.trim()),
      'qty': int.parse(_qtyText.trim()),
    };

    FeedbackUtil.showLoading('上传中...');
    await ProdTagApi.add(res);
    FeedbackUtil.showSuccess('上传成功');
    clearManualInput();
  }

  bool _validateForm() {
    _didAttemptSubmit = true;
    _qtyError = !_isPositiveInt(_qtyText);
    _grossWeightError = !_isPositiveDouble(_grossWeightText);
    _netWeightError = !_isPositiveDouble(_netWeightText);
    notifyListeners();
    return !_qtyError && !_grossWeightError && !_netWeightError;
  }

  void _resetFormState() {
    _qtyText = '';
    _grossWeightText = '';
    _netWeightText = '';
    _qtyError = false;
    _grossWeightError = false;
    _netWeightError = false;
    _didAttemptSubmit = false;
  }

  void clearManualInput() {
    _resetFormState();
    notifyListeners();
  }

  bool _isPositiveInt(String value) {
    final int? parsed = int.tryParse(value.trim());
    return parsed != null && parsed > 0;
  }

  bool _isPositiveDouble(String value) {
    final double? parsed = double.tryParse(value.trim());
    return parsed != null && parsed > 0;
  }
}

class CartonPrintScope extends InheritedNotifier<CartonPrintState> {
  const CartonPrintScope({
    super.key,
    required CartonPrintState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static CartonPrintState watch(BuildContext context) {
    final CartonPrintScope? scope =
        context.dependOnInheritedWidgetOfExactType<CartonPrintScope>();
    assert(scope != null, 'CartonPrintScope not found in context.');
    return scope!.notifier!;
  }

  static CartonPrintState read(BuildContext context) {
    final InheritedElement? element =
        context.getElementForInheritedWidgetOfExactType<CartonPrintScope>();
    final CartonPrintScope? scope = element?.widget as CartonPrintScope?;
    assert(scope != null, 'CartonPrintScope not found in context.');
    return scope!.notifier!;
  }
}
