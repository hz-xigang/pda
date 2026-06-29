import 'package:flutter/material.dart';
import 'package:hz_xg_pda/app_routes.dart';
import 'package:hz_xg_pda/components/app_bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<_WorkCardData> _cards = [
   /* _WorkCardData(
      title: '纸箱标签打印',
      accentColor: Color(0xFF2E61F3),
      iconBackground: Color(0xFFE7EEFF),
      icon: Icons.sell_outlined,
      routeName: AppRoutes.cartonLabelPrint,
    ),*/
    _WorkCardData(
      title: '打托作业',
      accentColor: Color(0xFF8B3DFF),
      iconBackground: Color(0xFFF1E8FF),
      icon: Icons.inventory_2_outlined,
      routeName: AppRoutes.palletOperation,
    ),
    _WorkCardData(
      title: '扫描入库',
      accentColor: Color(0xFF18A8F1),
      iconBackground: Color(0xFFE5F7FF),
      icon: Icons.qr_code_scanner_rounded,
      routeName: AppRoutes.palletInbound,
    ),
    _WorkCardData(
      title: '移库',
      accentColor: Color(0xFF00B894),
      iconBackground: Color(0xFFE3FBF5),
      icon: Icons.swap_horiz_rounded,
      routeName: AppRoutes.putawayMove,
    ),
    _WorkCardData(
      title: '盘点扫描',
      accentColor: Color(0xFFFFA000),
      iconBackground: Color(0xFFFFF4DB),
      icon: Icons.manage_search_rounded,
    ),
    _WorkCardData(
      title: '单据操作',
      accentColor: Color(0xFF0D8DBA),
      iconBackground: Color(0xFFE6F8FF),
      icon: Icons.receipt_long_outlined,
    ),
    _WorkCardData(
      title: '退货入库',
      accentColor: Color(0xFFFF4D5E),
      iconBackground: Color(0xFFFFEDF0),
      icon: Icons.assignment_return_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E2433),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.factory_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '仓储作业',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white.withValues(alpha: 0.08),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),
                    child: const Text(
                      '张工',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 118,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return _WorkCard(
                    data: _cards[index],
                    onTap: _cards[index].routeName == null
                        ? null
                        : () => Navigator.pushNamed(
                              context,
                              _cards[index].routeName!,
                            ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}

class _WorkCard extends StatelessWidget {
  const _WorkCard({
    required this.data,
    this.onTap,
  });

  final _WorkCardData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border(
                left: BorderSide(
                  color: data.accentColor,
                  width: 4,
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: data.iconBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    data.icon,
                    size: 24,
                    color: data.accentColor,
                  ),
                ),
                const Spacer(),
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkCardData {
  const _WorkCardData({
    required this.title,
    required this.accentColor,
    required this.iconBackground,
    required this.icon,
    this.routeName,
  });

  final String title;
  final Color accentColor;
  final Color iconBackground;
  final IconData icon;
  final String? routeName;
}
