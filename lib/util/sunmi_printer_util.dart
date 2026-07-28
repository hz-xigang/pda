import 'package:flutter/services.dart';
import 'package:sunmi_flutter_plugin_printer/bean/printer.dart';
import 'package:sunmi_flutter_plugin_printer/common/global_utils.dart';
import 'package:sunmi_flutter_plugin_printer/enum/align.dart' as printer;
import 'package:sunmi_flutter_plugin_printer/enum/error_level.dart';
import 'package:sunmi_flutter_plugin_printer/listener/printer_listener.dart';
import 'package:sunmi_flutter_plugin_printer/printer_sdk.dart';
import 'package:sunmi_flutter_plugin_printer/style/base_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/qr_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/text_style.dart' as printer;

/// 商米打印机工具类
class SunmiPrinterUtil {
  static Printer? _printer;
  static bool _isInitialized = false;

  /// 初始化打印机
  static Future<bool> init() async {
    if (_isInitialized && _printer != null) {
      return true;
    }

    try {
      await PrinterSdk.instance.getPrinter(_PrinterListener(
        onReady: (printer) {
          _printer = printer;
          _isInitialized = true;
        },
      ));
      return true;
    } catch (e) {
      GlobalUtils.logger.d("打印机初始化失败: $e");
      return false;
    }
  }

  /// 打印托盘二维码
  /// [qrContent] 二维码内容
  /// [title] 标题，默认"托盘二维码"
  static Future<void> printPalletQrCode(
    String qrContent, {
    String title = "托盘二维码",
  }) async {
    if (_printer == null) {
      throw Exception('打印机未初始化');
    }

    try {
      final lineApi = _printer?.lineApi;

      // 初始化行样式
      lineApi?.initLine(BaseStyle.getStyle());

      // 打印标题
      lineApi?.printText(
        "$title\n",
        printer.TextStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setTextSize(32)
            .enableBold(true),
      );

      // 打印分隔线
      lineApi?.printText(
        "================================\n",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      // 打印时间
      final now = DateTime.now();
      final timeStr =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

      lineApi?.printText(
        "打印时间: $timeStr\n\n",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      // 打印大尺寸二维码
      lineApi?.printQrCode(
        qrContent,
        QrStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setDot(10) // 大尺寸点阵
            .setErrorLevel(ErrorLevel.H), // 高纠错级别
      );

      // 打印二维码内容文本
      lineApi?.printText(
        "\n$qrContent\n",
        printer.TextStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setTextSize(20),
      );

      // 打印分隔线
      lineApi?.printText(
        "================================\n",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      // 打印提示信息
      lineApi?.printText(
        "请扫描二维码进行后续操作\n",
        printer.TextStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setTextSize(20),
      );

      // 打印空行并出纸
      lineApi?.printText("\n\n\n", printer.TextStyle.getStyle());
      lineApi?.autoOut();

      GlobalUtils.logger.d("托盘二维码打印成功: $qrContent");
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("打印异常: $e");
      throw Exception('打印失败: ${e.message}');
    } catch (e) {
      GlobalUtils.logger.d("打印异常: $e");
      throw Exception('打印失败: $e');
    }
  }

  /// 打印简单二维码（无标题装饰）
  static Future<void> printSimpleQrCode(String qrContent) async {
    if (_printer == null) {
      throw Exception('打印机未初始化');
    }

    try {
      final lineApi = _printer?.lineApi;
      lineApi?.initLine(BaseStyle.getStyle());

      // 打印大尺寸二维码
      lineApi?.printQrCode(
        qrContent,
        QrStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setDot(10)
            .setErrorLevel(ErrorLevel.H),
      );

      // 打印二维码内容
      lineApi?.printText(
        "\n$qrContent\n\n\n",
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
      );

      lineApi?.autoOut();
    } catch (e) {
      GlobalUtils.logger.d("打印异常: $e");
      throw Exception('打印失败: $e');
    }
  }

  /// 获取打印机实例（用于自定义打印）
  static Printer? getPrinter() => _printer;

  /// 检查打印机是否已初始化
  static bool get isReady => _isInitialized && _printer != null;
}

/// 打印机监听器
class _PrinterListener extends PrinterListener {
  final Function(Printer) onReady;

  _PrinterListener({required this.onReady});

  @override
  void onDefPrinter(Printer printer) {
    GlobalUtils.logger.d("打印机已连接: ${printer.toJson()}");
    onReady(printer);
  }
}
