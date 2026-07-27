import 'package:sunmi_flutter_plugin_printer/bean/printer.dart';
import 'package:sunmi_flutter_plugin_printer/common/global_utils.dart';
import 'package:sunmi_flutter_plugin_printer/listener/printer_listener.dart';

import 'common/global.dart';

class MyPrinterListener extends PrinterListener {
  @override
  void onDefPrinter(Printer var1) {
    GlobalUtils.logger.d("MyPrinterListener==>onDefPrinter: ${var1.toJson()}");
    Global.mPrinter = var1;
  }
}