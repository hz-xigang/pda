import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hz_xg_pda/app_routes.dart';
import 'package:hz_xg_pda/entity/login_user.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/entity/production_order.dart';
import 'package:hz_xg_pda/module_carton/list/list_index.dart';
import 'package:hz_xg_pda/module_carton/print/index.dart';
import 'package:hz_xg_pda/module_document_operation/index.dart';
import 'package:hz_xg_pda/module_pallet/print/index.dart';
import 'package:hz_xg_pda/module_putaway/inbound/index.dart';
import 'package:hz_xg_pda/module_putaway/move/index.dart';
import 'package:hz_xg_pda/page/home_page.dart';
import 'package:hz_xg_pda/page/login_page.dart';
import 'package:hz_xg_pda/page/mine_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LoginUserAdapter());
  Hive.registerAdapter(ProductionOrderAdapter());
  Hive.registerAdapter(ProdTagAdapter());
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );
  runApp(const WarehouseApp());
}

class WarehouseApp extends StatelessWidget {
  const WarehouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '仓储作业',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F6FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E61F3),
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.mine: (context) => const MinePage(),
        AppRoutes.cartonLabelPrint: (context) => CartonLabelPrintPage(),
        AppRoutes.cartonLabelList: (context) => const CartonLabelListPage(),
        AppRoutes.palletOperation: (context) => const PalletOperationPage(),
        AppRoutes.palletInbound: (context) => const InboundPage(),
        AppRoutes.putawayMove: (context) => const MovePage(),
        AppRoutes.documentOperation: (context) => const DocumentOperationPage(),
      },
      builder: EasyLoading.init(),
    );
  }
}
