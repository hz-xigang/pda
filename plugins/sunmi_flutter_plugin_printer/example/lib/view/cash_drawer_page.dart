
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sunmi_flutter_plugin_printer/common/global_utils.dart';
import 'package:flutter_printer_sample/my_print_result.dart';

import '../common/global.dart';
import '../widget/box_button.dart';

class CashDrawerPage extends StatefulWidget {
  const CashDrawerPage({super.key});

  @override
  State<StatefulWidget> createState() => _CashDrawerState();

}

class _CashDrawerState extends State<CashDrawerPage> {

  var cashDrawerApi = Global.mPrinter?.cashDrawerApi;
  String cashStatus = "";

  @override
  void initState() {
    super.initState();
    _getCashStatus();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        // padding: EdgeInsets.all(16), // 添加内边距
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // 让所有子组件水平居中
          children: [
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.text_cash_switch,
              onPressed: () {
                _cashOpen();
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.text_cash_status,
              onPressed: () {
                _getCashStatus();
              },
            ),
            SizedBox(height: 10),
            Padding(padding: EdgeInsets.only(left: 50, right: 50), child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LocalStr.of(context)!.text_cash, style: TextStyle(fontSize: 20),),
                Text(cashStatus, style: TextStyle(fontSize: 20),),
              ],
            ),)
          ],
        ),
      ),
    );
  }

  void _cashOpen() {
    try {
      cashDrawerApi?.open(MyPrintResult());
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }

  void _getCashStatus() async {
    try {
      var isOpen = await cashDrawerApi?.isOpen();
      setState(() {
        cashStatus = isOpen == true ? "on" : "off";
      });
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }

}