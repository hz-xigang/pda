import 'package:flutter/material.dart';
import 'package:flutter_printer_sample/app_shell.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_printer_sample/common/constants.dart';
import 'package:flutter_printer_sample/view/cash_drawer_page.dart';
import 'package:flutter_printer_sample/view/home_page.dart';
import 'package:flutter_printer_sample/view/print_cmd_page.dart';
import 'package:flutter_printer_sample/view/print_label_page.dart';
import 'package:flutter_printer_sample/view/print_ticket_page.dart';
import 'package:flutter_printer_sample/view/printer_info_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: Constants.ROUTE_HOME, //首页
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: Constants.ROUTE_PRINTER_INFO,
          builder: (context, state) => const PrinterInfoPage(),
        ),
        GoRoute(
          path: Constants.ROUTE_PRINT_TICKET,
          builder: (context, state) => const PrintTicketPage(),
        ),
        GoRoute(
          path: Constants.ROUTE_PRINT_LABEL,
          builder: (context, state) => const PrintLabelPage(),
        ),
        GoRoute(
          path: Constants.ROUTE_PRINT_CMD,
          builder: (context, state) => const PrintCmdPage(),
        ),
        GoRoute(
          path: Constants.ROUTE_CASH_DRAWER,
          builder: (context, state) => const CashDrawerPage(),
        )
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        LocalStr.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LocalStr.supportedLocales, // 自动识别 arb 中的 locale
    );
  }
}
