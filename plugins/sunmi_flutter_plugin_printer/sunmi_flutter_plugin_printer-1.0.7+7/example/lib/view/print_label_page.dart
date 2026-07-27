import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sunmi_flutter_plugin_printer/common/global_utils.dart';
import 'package:sunmi_flutter_plugin_printer/enum/human_readable.dart';
import 'package:sunmi_flutter_plugin_printer/enum/image_algorithm.dart';
import 'package:sunmi_flutter_plugin_printer/enum/rotate.dart';
import 'package:sunmi_flutter_plugin_printer/enum/shape.dart';
import 'package:sunmi_flutter_plugin_printer/style/area_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/barcode_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/bitmap_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/label_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/qr_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/text_style.dart' as printer;
import 'package:flutter_printer_sample/my_print_result.dart';

import '../common/global.dart';
import '../widget/box_button.dart' show BoxButton;

class PrintLabelPage extends StatefulWidget {
  const PrintLabelPage({super.key});

  @override
  State<PrintLabelPage> createState() => _PrintLabelPageState();
}

class _PrintLabelPageState extends State<PrintLabelPage> {
  var canvasApi = Global.mPrinter?.canvasApi;
  final TextEditingController _controller = TextEditingController();

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
            Row(
              children: [
                Text(
                  LocalStr.of(context)!.text_label_count,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'\d*')),
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.text_label_test1,
              onPressed: () {
                _printLabel1();
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.text_label_test2,
              onPressed: () {
                _printLabel2();
              },
            ),
            SizedBox(height: 10),
            BoxButton(
              title: LocalStr.of(context)!.text_label_test3,
              onPressed: () {
                _printLabel3();
              },
            ),
          ],
        ),
      ),
    );
  }

  int _getCount() {
    return int.tryParse(_controller.text) ?? 1;
  }

  /// 打印一张30*20mm 只包含内容的小标签
  /// 商米打印机可根据1mm = 8像素的关系构建标签内容
  void _printLabel1() {
    try {
      var labelStyle = LabelStyle.getStyle().setWidth(240).setHeight(160);
      canvasApi?.initCanvas(labelStyle);
      canvasApi?.renderArea(
        AreaStyle.getStyle()
            .setStyle(Shape.BOX)
            .setPosX(0)
            .setPosY(0)
            .setWidth(240)
            .setHeight(159),
      );
      canvasApi?.renderText(
        "品牌：SUNMI",
        printer.TextStyle.getStyle()
            .setTextSize(32)
            .enableBold(true)
            .setPosX(10)
            .setPosY(10),
      );
      canvasApi?.renderText(
        "商米是一家以“利他心”为核心价值观的物联网科技公司",
        printer.TextStyle.getStyle()
            .setTextSize(20)
            .setPosX(60)
            .setPosY(50)
            .setWidth(160)
            .setHeight(100),
      );
      canvasApi?.printCanvas(_getCount(), MyPrintResult());
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }

  /// 打印一张商品信息标签
  void _printLabel2() {
    try {
      canvasApi?.initCanvas(LabelStyle.getStyle().setWidth(384).setHeight(220));
      canvasApi?.renderArea(
        AreaStyle.getStyle()
            .setStyle(Shape.BOX)
            .setPosX(0)
            .setPosY(0)
            .setWidth(384)
            .setHeight(219),
      );
      canvasApi?.renderText(
        "可口可乐(2L)",
        printer.TextStyle.getStyle()
            .setTextSize(30)
            .enableBold(true)
            .setPosX(10)
            .setPosY(20),
      );
      canvasApi?.renderText(
        "2L",
        printer.TextStyle.getStyle().setTextSize(20).setPosX(10).setPosY(60),
      );
      canvasApi?.renderText(
        "200000",
        printer.TextStyle.getStyle().setTextSize(20).setPosX(10).setPosY(85),
      );
      canvasApi?.renderText(
        "瓶",
        printer.TextStyle.getStyle().setTextSize(24).setPosX(10).setPosY(130),
      );
      canvasApi?.renderBarCode(
        "12345678",
        BarcodeStyle.getStyle()
            .setPosX(200)
            .setPosY(60)
            .setReadable(HumanReadable.POS_TWO)
            .setDotWidth(2)
            .setBarHeight(60)
            .setWidth(160),
      );
      canvasApi?.renderText(
        "￥ 7.8",
        printer.TextStyle.getStyle()
            .setTextSize(16)
            .setTextWidthRatio(1)
            .setTextHeightRatio(1)
            .enableBold(true)
            .setPosX(190)
            .setPosY(160),
      );
      canvasApi?.printCanvas(_getCount(), MyPrintResult());
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }

  /// 打印一张品牌说明标签
  void _printLabel3() async {
    try {
      canvasApi?.initCanvas(LabelStyle.getStyle().setWidth(420).setHeight(220));
      canvasApi?.renderArea(
        AreaStyle.getStyle()
            .setStyle(Shape.BOX)
            .setPosX(0)
            .setPosY(0)
            .setWidth(420)
            .setHeight(219),
      );
      canvasApi?.renderQrCode(
        "www.sunmi.com",
        QrStyle.getStyle()
            .setDot(3)
            .setPosX(20)
            .setPosY(20)
            .setWidth(120)
            .setHeight(120),
      );
      canvasApi?.renderText(
        "SUNMITECH",
        printer.TextStyle.getStyle()
            .setPosX(140)
            .setPosY(20)
            .setRotate(Rotate.ROTATE_90),
      );
      canvasApi?.renderBarCode(
        "4006666509",
        BarcodeStyle.getStyle()
            .setPosX(180)
            .setPosY(50)
            .setReadable(HumanReadable.POS_TWO)
            .setWidth(220)
            .setHeight(90),
      );
      // 加载位图
      final ByteData data = await rootBundle.load('assets/images/sunmi.png');
      final Uint8List bitmap = data.buffer.asUint8List();
      canvasApi?.renderBitmap(
        bitmap,
        BitmapStyle.getStyle()
            .setAlgorithm(ImageAlgorithm.DITHERING)
            .setPosX(20)
            .setPosY(150)
            .setWidth(100)
            .setHeight(60),
      );
      canvasApi?.printCanvas(_getCount(), MyPrintResult());
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
  }
}
