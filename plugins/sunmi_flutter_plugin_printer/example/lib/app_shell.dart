import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_flutter_plugin_printer/common/global_utils.dart';
import 'package:sunmi_flutter_plugin_printer/printer_sdk.dart';
import 'package:flutter_printer_sample/view/home_page.dart';

import 'my_printer_listener.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  @override
  State<AppShell> createState() => _AppShellState();

}

class _AppShellState extends State<AppShell> {

  @override
  void initState() {
    super.initState();
    GlobalUtils.logger.d("_AppShellState => initState()");
    PrinterSdk.instance.getPrinter(MyPrinterListener());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false, // 默认不让自动返回
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) return;
          var childPage = widget.child is HomePage;
          GlobalUtils.logger.d("_AppShellState==> onPopInvokedWithResult: $didPop; $result; ${widget.child}; $childPage");
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            // 根页面，退出处理（可选）
            SystemNavigator.pop();
          }
        },
      child: Scaffold(
        appBar: AppBar(
          title: Text("FlutterPrinterSimple", style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xFF47455C),
          actions: [
            PopupMenuButton<int>(
              onSelected: (value) {
                // 处理按钮点击事件
                switch (value) {
                  case 1:
                    _log(true, "TTTTT");
                    break;
                  case 2:
                    _log(false, null);
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 1,
                  child: Text('Log On'),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text('Log Off'),
                ),
              ],
              icon: Icon(CupertinoIcons.info, color: Colors.grey,), // 右侧图标
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0), // 下划线的高度
            child: Container(
              color: Colors.grey, // 下划线的颜色
              height: 1.0, // 下划线的高度
            ),
          ),
        ),
        body: widget.child,
      ),
    );
  }

  void _log(bool enable, String? tag) {
    try {
      PrinterSdk.instance.log(enable, tag);
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }
  
}