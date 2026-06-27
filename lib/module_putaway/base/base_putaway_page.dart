import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/app_back_bar.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';

typedef PutawayScopeBuilder<T extends ChangeNotifier> = Widget Function(
  T notifier,
  Widget child,
);

class BasePutawayPage<T extends ChangeNotifier> extends StatefulWidget {
  const BasePutawayPage({
    super.key,
    required this.createNotifier,
    required this.scopeBuilder,
    required this.onScan,
    required this.child,
  });

  final T Function() createNotifier;
  final PutawayScopeBuilder<T> scopeBuilder;
  final Future<void> Function(T notifier, String result, BuildContext context)
      onScan;
  final Widget child;

  @override
  State<BasePutawayPage<T>> createState() => _BasePutawayPageState<T>();
}

class _BasePutawayPageState<T extends ChangeNotifier>
    extends State<BasePutawayPage<T>> {
  StreamSubscription<String>? _scanSubscription;
  late final T _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = widget.createNotifier();
    _scanSubscription = PdaUtil().onScanResult.listen((result) {
      widget.onScan(_notifier, result, context);
    });
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: SafeArea(
        child: widget.scopeBuilder(
          _notifier,
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class BasePutawayBody extends StatelessWidget {
  const BasePutawayBody({
    super.key,
    required this.stepIndicator,
    required this.totalCount,
    required this.productList,
    required this.locationSection,
    required this.confirmBar,
  });

  final Widget stepIndicator;
  final Widget totalCount;
  final Widget productList;
  final Widget locationSection;
  final Widget confirmBar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBackBar(onTap: () => Navigator.pop(context)),
        const SizedBox(height: 12),
        stepIndicator,
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),
                totalCount,
                const SizedBox(height: 16),
                productList,
                const SizedBox(height: 16),
                locationSection,
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        confirmBar,
      ],
    );
  }
}
