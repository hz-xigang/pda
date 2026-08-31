import 'package:flutter/material.dart';

class AppRoutes {
  const AppRoutes._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String login = '/';
  static const String home = '/home';
  static const String mine = '/mine';
  static const String cartonLabelPrint = '/carton-label-print';
  static const String cartonLabelList = '/carton-label-list';
  static const String palletOperation = '/pallet-operation';
  static const String palletUnbundle = '/pallet-unbundle';
  static const String palletInbound = '/pallet-inbound';
  static const String returnInbound = '/return-inbound';
  static const String putawayMove = '/putaway-move';
  static const String documentOperation = '/document-operation';
  static const String sunmiPrinterTest = '/sunmi-printer-test';
}
