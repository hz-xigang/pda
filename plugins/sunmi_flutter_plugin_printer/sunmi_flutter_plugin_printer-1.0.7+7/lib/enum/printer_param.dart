///打印机参数枚举类
enum PrinterParam {
  RUNTIME_ADC,
  HIGH_ADC,
  LOW_ADC,
  PWM,
  PWM_ADC,
  GPIO_PIN,
  GPIO_STATE,
  NULL;

  // 匹配对应的枚举类型
  static PrinterParam findParam(String info) {
    return PrinterParam.values.firstWhere(
          (param) => param.toString().split('.').last == info,
      orElse: () => PrinterParam.NULL,
    );
  }
}
