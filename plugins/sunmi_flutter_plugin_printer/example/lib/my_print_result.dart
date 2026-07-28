import 'package:sunmi_flutter_plugin_printer/common/global_utils.dart' show GlobalUtils;
import 'package:sunmi_flutter_plugin_printer/listener/print_result.dart';

class MyPrintResult extends PrintResult {
  @override
  void onResult(int? resultCode, String? message) {
    GlobalUtils.logger.d("MyPrintResult==>onResult: $resultCode; $message");
    if (resultCode == 0) {
      //success
    } else {

    }

  }

}