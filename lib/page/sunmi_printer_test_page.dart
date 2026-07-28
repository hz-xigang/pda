import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_flutter_plugin_printer/bean/printer.dart';
import 'package:sunmi_flutter_plugin_printer/common/global_utils.dart';
import 'package:sunmi_flutter_plugin_printer/enum/align.dart' as printer;
import 'package:sunmi_flutter_plugin_printer/enum/error_level.dart';
import 'package:sunmi_flutter_plugin_printer/enum/human_readable.dart';
import 'package:sunmi_flutter_plugin_printer/enum/printer_info.dart';
import 'package:sunmi_flutter_plugin_printer/listener/printer_listener.dart';
import 'package:sunmi_flutter_plugin_printer/printer_sdk.dart';
import 'package:sunmi_flutter_plugin_printer/style/barcode_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/base_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/qr_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/text_style.dart' as printer;

class SunmiPrinterTestPage extends StatefulWidget {
  const SunmiPrinterTestPage({super.key});

  @override
  State<SunmiPrinterTestPage> createState() => _SunmiPrinterTestPageState();
}

class _SunmiPrinterTestPageState extends State<SunmiPrinterTestPage> {
  Printer? _printer;
  String _statusText = '初始化中...';
  String? _printerName;
  String? _printerStatus;
  String? _printerType;

  @override
  void initState() {
    super.initState();
    _initPrinter();
  }

  Future<void> _initPrinter() async {
    try {
      // 获取打印机实例
      await PrinterSdk.instance.getPrinter(_MyPrinterListener(
        onPrinterReady: (printer) {
          setState(() {
            _printer = printer;
            _statusText = '打印机已连接';
          });
          _getPrinterInfo();
        },
      ));
    } catch (e) {
      setState(() {
        _statusText = '初始化失败: $e';
      });
    }
  }

  Future<void> _getPrinterInfo() async {
    if (_printer == null) return;

    try {
      final name = await _printer?.queryApi.getInfo(PrinterInfo.NAME);
      final status = (await _printer?.queryApi.getStatus())?.name;
      final type = await _printer?.queryApi.getInfo(PrinterInfo.TYPE);

      setState(() {
        _printerName = name;
        _printerStatus = status;
        _printerType = type;
      });
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("获取打印机信息失败: $e");
    }
  }

  Future<void> _printTestText() async {
    if (_printer == null) {
      _showMessage('打印机未就绪');
      return;
    }

    try {
      final lineApi = _printer?.lineApi;

      // 初始化行样式
      lineApi?.initLine(BaseStyle.getStyle());

      // 打印标题 - 居中
      lineApi?.printText(
        "商米打印机测试",
        printer.TextStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setTextSize(32),
      );

      // 打印分隔线
      lineApi?.printText(
        "--------------------------------",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      // 打印普通文本
      lineApi?.printText(
        "这是测试文本",
        printer.TextStyle.getStyle(),
      );

      // 打印不同风格的文本
      lineApi?.addText("普通 ", printer.TextStyle.getStyle());
      lineApi?.addText(
        "加粗 ",
        printer.TextStyle.getStyle().enableBold(true),
      );
      lineApi?.addText(
        "下划线 ",
        printer.TextStyle.getStyle().enableUnderline(true),
      );
      lineApi?.addText("\n", printer.TextStyle.getStyle());

      // 打印三列文本
      lineApi?.printTexts(
        ["商品", "数量", "价格"],
        [2, 1, 1],
        [
          printer.TextStyle.getStyle().setAlign(printer.Align.LEFT),
          printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
          printer.TextStyle.getStyle().setAlign(printer.Align.RIGHT),
        ],
      );

      lineApi?.printTexts(
        ["测试商品A", "10", "¥100"],
        [2, 1, 1],
        [
          printer.TextStyle.getStyle().setAlign(printer.Align.LEFT),
          printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
          printer.TextStyle.getStyle().setAlign(printer.Align.RIGHT),
        ],
      );

      // 打印分隔线
      lineApi?.printText(
        "--------------------------------",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      // 打印合计
      lineApi?.printTexts(
        ["合计:", "¥100"],
        [3, 1],
        [
          printer.TextStyle.getStyle()
              .setAlign(printer.Align.LEFT)
              .enableBold(true),
          printer.TextStyle.getStyle()
              .setAlign(printer.Align.RIGHT)
              .enableBold(true),
        ],
      );

      // 打印底部信息
      lineApi?.printText(
        "\n感谢惠顾！",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      // 打印空行并出纸
      lineApi?.printText("\n\n\n", printer.TextStyle.getStyle());
      lineApi?.autoOut();

      _showMessage('打印成功');
    } on PlatformException catch (e) {
      _showMessage('打印失败: ${e.message}');
      GlobalUtils.logger.d("打印异常: $e");
    } catch (e) {
      _showMessage('打印失败: $e');
      GlobalUtils.logger.d("打印异常: $e");
    }
  }

  Future<void> _printSimpleText() async {
    if (_printer == null) {
      _showMessage('打印机未就绪');
      return;
    }

    try {
      final lineApi = _printer?.lineApi;
      lineApi?.initLine(BaseStyle.getStyle());
      lineApi?.printText(
        "简单测试文本\n",
        printer.TextStyle.getStyle(),
      );
      lineApi?.printText(
        "打印时间: ${DateTime.now().toString().substring(0, 19)}\n\n",
        printer.TextStyle.getStyle(),
      );
      lineApi?.autoOut();

      _showMessage('打印成功');
    } catch (e) {
      _showMessage('打印失败: $e');
    }
  }

  Future<void> _printQrCode() async {
    if (_printer == null) {
      _showMessage('打印机未就绪');
      return;
    }

    try {
      final lineApi = _printer?.lineApi;

      // 打印标题
      lineApi?.initLine(BaseStyle.getStyle());
      lineApi?.printText(
        "二维码打印测试\n",
        printer.TextStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setTextSize(28),
      );

      // 打印二维码 - 小尺寸
      lineApi?.printQrCode(
        "https://www.sunmi.com",
        QrStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setDot(6) // 二维码点阵大小
            .setErrorLevel(ErrorLevel.L), // 纠错级别 L/M/Q/H
      );

      // 打印二维码下方的文本
      lineApi?.initLine(BaseStyle.getStyle().setAlign(printer.Align.CENTER));
      lineApi?.printText(
        "小尺寸: https://www.sunmi.com\n\n",
        printer.TextStyle.getStyle().setTextSize(20),
      );

      // 打印二维码 - 大尺寸
      lineApi?.printQrCode(
        "订单号: HZ-XG-2026-0001",
        QrStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setDot(9) // 更大的点阵
            .setErrorLevel(ErrorLevel.H), // 高纠错级别
      );

      lineApi?.printText(
        "大尺寸: 订单号 HZ-XG-2026-0001\n\n",
        printer.TextStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .enableBold(true),
      );

      // 打印完成
      lineApi?.printText("\n", printer.TextStyle.getStyle());
      lineApi?.autoOut();

      _showMessage('二维码打印成功');
    } on PlatformException catch (e) {
      _showMessage('打印失败: ${e.message}');
      GlobalUtils.logger.d("打印异常: $e");
    } catch (e) {
      _showMessage('打印失败: $e');
      GlobalUtils.logger.d("打印异常: $e");
    }
  }

  Future<void> _printBarCode() async {
    if (_printer == null) {
      _showMessage('打印机未就绪');
      return;
    }

    try {
      final lineApi = _printer?.lineApi;

      // 打印标题
      lineApi?.initLine(BaseStyle.getStyle());
      lineApi?.printText(
        "条形码打印测试\n\n",
        printer.TextStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setTextSize(28),
      );

      // 打印条形码 - 标准尺寸
      var barcodeStyle = BarcodeStyle.getStyle()
          .setAlign(printer.Align.CENTER)
          .setDotWidth(2) // 条码宽度
          .setBarHeight(100) // 条码高度
          .setReadable(HumanReadable.POS_TWO); // 可读文本位置：在下方

      lineApi?.printBarCode("0123456789", barcodeStyle);
      lineApi?.printText(
        "标准条码\n\n",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      // 打印条形码 - 带字母
      lineApi?.printBarCode("HZ2026XG0001", barcodeStyle);
      lineApi?.printText(
        "订单条码\n\n",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      // 打印条形码 - 自定义宽度（适用于长条码）
      barcodeStyle.setWidth(384); // 设置最大宽度
      lineApi?.printBarCode("987654321098765432", barcodeStyle);
      lineApi?.printText(
        "宽条码\n\n",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      // 打印完成
      lineApi?.printText("\n", printer.TextStyle.getStyle());
      lineApi?.autoOut();

      _showMessage('条形码打印成功');
    } on PlatformException catch (e) {
      _showMessage('打印失败: ${e.message}');
      GlobalUtils.logger.d("打印异常: $e");
    } catch (e) {
      _showMessage('打印失败: $e');
      GlobalUtils.logger.d("打印异常: $e");
    }
  }

  Future<void> _printQrAndBarcode() async {
    if (_printer == null) {
      _showMessage('打印机未就绪');
      return;
    }

    try {
      final lineApi = _printer?.lineApi;

      // 打印订单小票样式
      lineApi?.initLine(BaseStyle.getStyle());

      // 标题
      lineApi?.printText(
        "矽钢 PDA 系统\n",
        printer.TextStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setTextSize(32)
            .enableBold(true),
      );

      lineApi?.printText(
        "--------------------------------\n",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      // 订单信息
      lineApi?.printTexts(
        ["订单号:", "HZ-XG-2026-0001"],
        [1, 2],
        [
          printer.TextStyle.getStyle().setAlign(printer.Align.LEFT),
          printer.TextStyle.getStyle()
              .setAlign(printer.Align.RIGHT)
              .enableBold(true),
        ],
      );

      lineApi?.printTexts(
        ["操作员:", "张三"],
        [1, 2],
        [
          printer.TextStyle.getStyle().setAlign(printer.Align.LEFT),
          printer.TextStyle.getStyle().setAlign(printer.Align.RIGHT),
        ],
      );

      lineApi?.printTexts(
        ["时间:", DateTime.now().toString().substring(0, 19)],
        [1, 2],
        [
          printer.TextStyle.getStyle().setAlign(printer.Align.LEFT),
          printer.TextStyle.getStyle().setAlign(printer.Align.RIGHT),
        ],
      );

      lineApi?.printText(
        "--------------------------------\n",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      // 打印订单条码
      lineApi?.printBarCode(
        "HZ2026XG0001",
        BarcodeStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setDotWidth(2)
            .setBarHeight(80)
            .setReadable(HumanReadable.POS_TWO),
      );

      lineApi?.printText("\n", printer.TextStyle.getStyle());

      // 打印二维码
      lineApi?.printQrCode(
        "ORDER:HZ-XG-2026-0001|OPERATOR:张三|TIME:${DateTime.now().toString().substring(0, 19)}",
        QrStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setDot(8)
            .setErrorLevel(ErrorLevel.M),
      );

      lineApi?.printText(
        "\n扫描二维码查看详情\n",
        printer.TextStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setTextSize(20),
      );

      // 底部信息
      lineApi?.printText(
        "--------------------------------\n",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      lineApi?.printText(
        "感谢使用\n\n\n",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      lineApi?.autoOut();

      _showMessage('综合打印成功');
    } on PlatformException catch (e) {
      _showMessage('打印失败: ${e.message}');
      GlobalUtils.logger.d("打印异常: $e");
    } catch (e) {
      _showMessage('打印失败: $e');
      GlobalUtils.logger.d("打印异常: $e");
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商米打印机测试'),
        backgroundColor: const Color(0xFF2E61F3),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 状态卡片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '打印机状态',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('连接状态', _statusText),
                    if (_printerName != null)
                      _buildInfoRow('打印机名称', _printerName!),
                    if (_printerStatus != null)
                      _buildInfoRow('打印机状态', _printerStatus!),
                    if (_printerType != null)
                      _buildInfoRow('打印机型号', _printerType!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 测试按钮
            Text(
              '打印测试',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _printer != null ? _printSimpleText : null,
              icon: const Icon(Icons.print),
              label: const Text('简单文本打印'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF2E61F3),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _printer != null ? _printTestText : null,
              icon: const Icon(Icons.receipt_long),
              label: const Text('完整小票打印'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF2E61F3),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _printer != null ? _printQrCode : null,
              icon: const Icon(Icons.qr_code),
              label: const Text('二维码打印'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF2E61F3),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _printer != null ? _printBarCode : null,
              icon: const Icon(Icons.barcode_reader),
              label: const Text('条形码打印'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF2E61F3),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _printer != null ? _printQrAndBarcode : null,
              icon: const Icon(Icons.receipt),
              label: const Text('综合打印（二维码+条码）'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _getPrinterInfo,
              icon: const Icon(Icons.refresh),
              label: const Text('刷新打印机信息'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// 打印机监听器
class _MyPrinterListener extends PrinterListener {
  final Function(Printer) onPrinterReady;

  _MyPrinterListener({required this.onPrinterReady});

  @override
  void onDefPrinter(Printer printer) {
    GlobalUtils.logger.d("打印机已连接: ${printer.toJson()}");
    onPrinterReady(printer);
  }
}
