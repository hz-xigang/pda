import 'package:flutter/material.dart';
import 'package:flutter_printer_sample/common/constants.dart';
import 'package:go_router/go_router.dart';

import '../widget/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomePage extends StatelessWidget {

  const HomePage({super.key});

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
              title: LocalStr.of(context)!.title_info,
              onPressed: () {
                _toPrinterInfoPage(context);
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.title_ticket,
              onPressed: () {
                _toPrintTicketPage(context);
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.title_label,
              onPressed: () {
                _toPrintLabelPage(context);
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.title_command,
              onPressed: () {
                _toPrintCmdPage(context);
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.title_cash,
              onPressed: () {
                _toCashDrawerPage(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toPrinterInfoPage(BuildContext context) {
    /// 保留当前页面，可回退
    context.push(Constants.ROUTE_PRINTER_INFO);
    /// 替换当前页面，不可返回
    // context.go(Constants.ROUTE_PAGE_PRINTER_INFO);
  }

  void _toPrintTicketPage(BuildContext context) {
    /// 保留当前页面，可回退
    context.push(Constants.ROUTE_PRINT_TICKET);
  }

  void _toPrintLabelPage(BuildContext context) {
    context.push(Constants.ROUTE_PRINT_LABEL);
  }

  void _toPrintCmdPage(BuildContext context) {
    context.push(Constants.ROUTE_PRINT_CMD);
  }

  void _toCashDrawerPage(BuildContext context) {
    context.push(Constants.ROUTE_CASH_DRAWER);
  }
}
