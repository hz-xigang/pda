import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_flutter_plugin_printer/common/global_utils.dart';
import 'package:sunmi_flutter_plugin_printer/enum/dividing_line.dart';
import 'package:sunmi_flutter_plugin_printer/enum/error_level.dart';
import 'package:sunmi_flutter_plugin_printer/enum/human_readable.dart';
import 'package:sunmi_flutter_plugin_printer/enum/image_algorithm.dart';
import 'package:sunmi_flutter_plugin_printer/style/barcode_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/base_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/bitmap_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/qr_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/text_style.dart' as printer;
import 'package:sunmi_flutter_plugin_printer/enum/align.dart' as printer;
import 'package:flutter_printer_sample/my_print_result.dart';

import '../common/global.dart';
import '../widget/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrintTicketPage extends StatefulWidget {
  const PrintTicketPage({super.key});

  @override
  State<PrintTicketPage> createState() => _PrintTicketPageState();
}

class _PrintTicketPageState extends State<PrintTicketPage> {
  var lineApi = Global.mPrinter?.lineApi;

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
            // 从资产加载图片
            // Image.asset('assets/images/sunmi.png'),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.text_ticket_text,
              onPressed: () {
                _printText();
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.text_ticket_texts,
              onPressed: () {
                _printTexts();
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.text_ticket_bar,
              onPressed: () {
                _printBar();
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.text_ticket_qr,
              onPressed: () {
                _printQr();
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.text_ticket_logo,
              onPressed: () {
                _printBitmap(context);
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.text_ticket_line,
              onPressed: () {
                _printLine();
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.text_ticket_all,
              onPressed: () {
                _printTicket();
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.text_ticket_result,
              onPressed: () {
                _printTicketAndListen();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 文本打印例子
  /// 通过initLine设置行内大小和行内文本对齐方式
  /// 通过printText直接打印整行内容
  /// 通过addText控制每次打印的内容
  /// 局部反白和文本倒置需要Sunmi 3.0字体支持
  void _printText() {
    try {
      lineApi?.initLine(BaseStyle.getStyle());
      lineApi?.printText("这行内容将直接打印出", printer.TextStyle.getStyle());
      lineApi?.addText("不同风格的内容:", printer.TextStyle.getStyle());
      lineApi?.addText("加粗", printer.TextStyle.getStyle().enableBold(true));
      lineApi?.addText(
        "下划线",
        printer.TextStyle.getStyle().enableUnderline(true),
      );
      lineApi?.addText(
        "删除线",
        printer.TextStyle.getStyle().enableStrikethrough(true),
      );
      lineApi?.addText("倾斜", printer.TextStyle.getStyle().enableItalics(true));
      lineApi?.addText("\n", printer.TextStyle.getStyle());
      lineApi?.autoOut();
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }

  /// 按列打印文本例子
  void _printTexts() {
    try {
      var textStyle = printer.TextStyle.getStyle().setAlign(
        printer.Align.CENTER,
      );
      lineApi?.printTexts(["第一列", "第二列", "第三列"], [1, 1, 1], [
        textStyle,
        textStyle,
        textStyle,
      ]);
      lineApi?.printTexts(["第一列", "第二列", "第三列"], [1, 1, 1], [
        printer.TextStyle.getStyle().setAlign(printer.Align.LEFT),
        printer.TextStyle.getStyle().setAlign(printer.Align.CENTER),
        printer.TextStyle.getStyle().setAlign(printer.Align.RIGHT),
      ]);
      var textStyle1 = printer.TextStyle.getStyle().setAlign(
        printer.Align.LEFT,
      );
      lineApi?.printTexts(["第一列", "第二列", "第三列"], [1, 1, 1], [
        textStyle1,
        textStyle1,
        textStyle1,
      ]);
      lineApi?.autoOut();
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }

  /// 打印条码例子
  /// 演示打印几段条码内容
  /// 如果条码内容过长会导致显示异常，此时需要根据需要自定义条码的宽度
  /// （自定义条码宽度可能影响条码的识别效果）
  void _printBar() {
    try {
      var barcodeStyle = BarcodeStyle.getStyle()
          .setAlign(printer.Align.CENTER)
          .setDotWidth(2)
          .setBarHeight(100)
          .setReadable(HumanReadable.POS_TWO);
      lineApi?.printBarCode("0123456789", barcodeStyle);
      lineApi?.printBarCode("0123456789ABCDEFG", barcodeStyle);
      barcodeStyle.setWidth(384);
      lineApi?.printBarCode("0123456789ABCDEFG", barcodeStyle);
      lineApi?.autoOut();
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }

  /// 打印Qr码例子
  void _printQr() {
    try {
      lineApi?.printQrCode(
        "http://www.sunmi.com",
        QrStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setDot(9)
            .setErrorLevel(ErrorLevel.L),
      );
      lineApi?.initLine(BaseStyle.getStyle().setAlign(printer.Align.CENTER));
      lineApi?.printText(
        "http://www.sunmi.com",
        printer.TextStyle.getStyle().enableBold(true),
      );
      lineApi?.autoOut();
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }

  /// 打印Logo的例子
  /// 分别使用二值化处理图片和抖动算法处理图片
  /// 由于logo本身透明背景橙色字体，使用二值化处理后通过设置阈值呈现不同效果
  void _printBitmap(BuildContext context) async {
    try {
      final ByteData byteData = await rootBundle.load(
        'assets/images/sunmi.png',
      ); // 读取 assets
      final Uint8List bitmap = byteData.buffer.asUint8List();
      lineApi?.printBitmap(
        bitmap,
        BitmapStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setAlgorithm(ImageAlgorithm.BINARIZATION)
            .setValue(120)
            .setWidth(384)
            .setHeight(150),
      );
      lineApi?.printBitmap(
        bitmap,
        BitmapStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setAlgorithm(ImageAlgorithm.DITHERING)
            .setWidth(384)
            .setHeight(150),
      );
      lineApi?.autoOut();
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }

  /// 打印分割线的例子
  /// 分割线包括空白线，每行打印内容可以通过空白线进行分割
  void _printLine() {
    try {
      lineApi?.printDividingLine(DividingLine.EMPTY, 20);
      lineApi?.printDividingLine(DividingLine.DOTTED, 5);
      lineApi?.printDividingLine(DividingLine.EMPTY, 20);
      lineApi?.printDividingLine(DividingLine.SOLID, 10);
      lineApi?.autoOut();
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }

  Future<void> _printTicket() async {
    try {
      // 初始化打印行
      lineApi?.initLine(BaseStyle.getStyle().setAlign(printer.Align.CENTER));

      // 打印标题
      lineApi?.addText("******", printer.TextStyle.getStyle());
      lineApi?.addText(
        "商米之家",
        printer.TextStyle.getStyle()
            .enableBold(true)
            .setTextWidthRatio(1)
            .setTextHeightRatio(1),
      );
      lineApi?.printText("******", printer.TextStyle.getStyle());

      // 加载位图
      final ByteData data = await rootBundle.load('assets/images/sunmi.png');
      final Uint8List bitmap = data.buffer.asUint8List();

      // 打印位图
      lineApi?.printBitmap(
        bitmap,
        BitmapStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setAlgorithm(ImageAlgorithm.BINARIZATION)
            .setValue(120)
            .setWidth(384)
            .setHeight(150),
      );

      // 打印分隔线
      lineApi?.printDividingLine(DividingLine.EMPTY, 30);
      lineApi?.printDividingLine(DividingLine.DOTTED, 2);
      lineApi?.printDividingLine(DividingLine.EMPTY, 30);

      // 打印商品信息
      final textStyle = printer.TextStyle.getStyle().setAlign(
        printer.Align.LEFT,
      );
      lineApi?.printTexts(["商品1", "商品12", "商品13"], [1, 1, 1], [
        textStyle,
        textStyle,
        textStyle,
      ]);
      lineApi?.printTexts(["商品21", "商品22", "商品23"], [1, 1, 1], [
        textStyle,
        textStyle,
        textStyle,
      ]);
      lineApi?.printTexts(["商品31", "商品32", "商品33"], [1, 1, 1], [
        textStyle,
        textStyle,
        textStyle,
      ]);

      // 打印条码信息
      lineApi?.printText("商品信息条码信息:", printer.TextStyle.getStyle());
      lineApi?.printBarCode(
        "1234567890",
        BarcodeStyle.getStyle()
            .setAlign(printer.Align.CENTER)
            .setReadable(HumanReadable.POS_TWO),
      );

      // 打印分隔线
      lineApi?.printDividingLine(DividingLine.EMPTY, 30);
      lineApi?.printDividingLine(DividingLine.DOTTED, 2);

      // 打印支付信息
      lineApi?.initLine(BaseStyle.getStyle().setAlign(printer.Align.CENTER));
      lineApi?.printText(
        "--已支付--",
        printer.TextStyle.getStyle().setTextSize(48),
      );
      lineApi?.printText(
        "预计19：00送达",
        printer.TextStyle.getStyle().setTextSize(48),
      );

      // 打印下单时间和备注
      lineApi?.initLine(BaseStyle.getStyle().setAlign(printer.Align.LEFT));
      lineApi?.printText("【下单时间】2021-8-1 12:00", printer.TextStyle.getStyle());
      lineApi?.addText("【备注】", printer.TextStyle.getStyle());
      lineApi?.printText(
        "尽快送达",
        printer.TextStyle.getStyle().setTextHeightRatio(2),
      );

      // 打印分隔线
      lineApi?.printDividingLine(DividingLine.EMPTY, 30);
      lineApi?.printDividingLine(DividingLine.DOTTED, 2);

      // 打印发票抬头和二维码
      lineApi?.printText(
        "【发票抬头】",
        printer.TextStyle.getStyle().setTextSize(16),
      );
      lineApi?.printQrCode(
        "1234567890",
        QrStyle.getStyle().setDot(9).setAlign(printer.Align.CENTER),
      );

      // 自动输出
      lineApi?.autoOut();
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }

  /// 需要监听打印结果时可以开启事务模式
  /// 开启后每次打印内容时通过printTrans监听回调即可获取结果
  void _printTicketAndListen() async {
    try {
      //需要监听打印结果时可以开启事务模式
      lineApi?.enableTransMode(true);

      //正常打印票据
      await _printTicket();
      //事务监听结果
      lineApi?.printTrans(MyPrintResult());
      lineApi?.enableTransMode(false);
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }
}
