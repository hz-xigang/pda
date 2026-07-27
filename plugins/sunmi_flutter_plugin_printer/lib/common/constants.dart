class Constants {
  static const METHOD_CHANNEL = "flutter_plugin_printer";
  static const EVENT_CHANNEL_NAME = "flutter_plugin_printer_event";

  static const METHOD_MY_FIRST_CHANNEL_TEST = "getMyFirstChannelTest";

  static const METHOD_PRINT_TEXT_TEST = "printTextTest";

  static const METHOD_PRINT_GET_PRINTER = "printGetPrinter";
  static const METHOD_PRINT_LOG = "printSetLog";
  static const METHOD_PRINT_DESTROY = "printDestroy";
  static const METHOD_PRINT_START_SETTING = "printStartSetting";

  static const METHOD_QUERY_GET_STATUS = "queryGetStatus";
  static const METHOD_QUERY_GET_INFO = "queryGetInfo";

  static const METHOD_COMMAND_SEND_ESC = "commandSendEsc";
  static const METHOD_COMMAND_SEND_TSPL = "commandSendTspl";

  static const METHOD_LINE_INIT_LINE = "lineInitLine";
  static const METHOD_LINE_ADD_TEXT = "lineAddText";
  static const METHOD_LINE_PRINT_TEXT = "linePrintText";
  static const METHOD_LINE_PRINT_TEXTS = "linePrintTexts";
  static const METHOD_LINE_PRINT_BARCODE = "linePrintBarcode";
  static const METHOD_LINE_PRINT_QRCODE = "linePrintQrcode";
  static const METHOD_LINE_PRINT_BITMAP = "linePrintBitmap";
  static const METHOD_LINE_PRINT_DIVIDING_LINE = "linePrintDividingLine";
  static const METHOD_LINE_AUTO_OUT = "lineAutoOut";
  static const METHOD_LINE_ENABLE_TRANS_MODE = "lineEnableTransMode";
  static const METHOD_LINE_PRINT_TRANS = "linePrintTrans";

  static const METHOD_CANVAS_INIT_CANVAS = "canvasInitCanvas";
  static const METHOD_CANVAS_RENDER_TEXT = "canvasRenderText";
  static const METHOD_CANVAS_RENDER_BARCODE = "canvasRenderBarcode";
  static const METHOD_CANVAS_RENDER_QRCODE = "canvasRenderQrcode";
  static const METHOD_CANVAS_RENDER_BITMAP = "canvasRenderBitmap";
  static const METHOD_CANVAS_RENDER_AREA = "canvasRenderArea";
  static const METHOD_CANVAS_PRINT_CANVAS = "canvasPrintCanvas";

  static const METHOD_CASH_DRAWER_TO_OPEN = "cashDrawerToOpen";
  static const METHOD_CASH_DRAWER_IS_OPEN = "cashDrawerIsOpen";
}