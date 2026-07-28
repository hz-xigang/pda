import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_flutter_plugin_printer/common/global_utils.dart';
import 'package:sunmi_flutter_plugin_printer/enum/printer_info.dart';
import 'package:flutter_printer_sample/common/global.dart';
import 'package:flutter_printer_sample/widget/title_name_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrinterInfoPage extends StatefulWidget {
  const PrinterInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _PrinterInfoState();
}

class _PrinterInfoState extends State<PrinterInfoPage> {
  var mPrinter = Global.mPrinter;
  String? printerName;
  String? printerStatus;
  String? printerType;
  String? printerPaper;

  @override
  void initState() {
    super.initState();
    _getPrinterInfo();
  }

  Future<void> _getPrinterInfo() async {
    String? name;
    String? status;
    String? type;
    String? paper;

    try {
      name = await mPrinter?.queryApi.getInfo(PrinterInfo.NAME);
      status = (await mPrinter?.queryApi.getStatus())?.name;
      type = await mPrinter?.queryApi.getInfo(PrinterInfo.TYPE);
      paper = await mPrinter?.queryApi.getInfo(PrinterInfo.PAPER);
    } on PlatformException catch (e) {
      GlobalUtils.logger.d("PlatformException: $e");
    } catch (e) {
      GlobalUtils.logger.d("Exception: $e");
    }
    setState(() {
      printerName = name;
      printerStatus = status;
      printerType = type;
      printerPaper = paper;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleNameWidget(
          title: LocalStr.of(context)?.text_printer_id,
          name: mPrinter?.printerId,
        ),
        TitleNameWidget(
          title: LocalStr.of(context)?.text_name,
          name: printerName,
        ),
        TitleNameWidget(
          title: LocalStr.of(context)?.text_status,
          name: printerStatus,
        ),
        TitleNameWidget(
          title: LocalStr.of(context)?.text_type,
          name: printerType,
        ),
        TitleNameWidget(
          title: LocalStr.of(context)?.text_paper,
          name: printerPaper,
        ),
      ],
    );
  }
}
