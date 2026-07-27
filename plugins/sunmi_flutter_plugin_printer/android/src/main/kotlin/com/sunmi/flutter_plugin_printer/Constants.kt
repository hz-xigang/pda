package com.sunmi.flutter_plugin_printer


/**
 * Author: Dean
 * Time: 2025/5/16 13:58
 * Email: mengqi.wu01@sunmi.com
 */

object Constants {
    const val METHOD_CHANNEL_NAME = "flutter_plugin_printer"
    const val EVENT_CHANNEL_NAME = "flutter_plugin_printer_event"

    /**  =====Test=====  */
    const val METHOD_GET_PLATFORM_VERSION = "getPlatformVersion"
    const val METHOD_GET_MY_FIRST_CHANNEL_TEST = "getMyFirstChannelTest"
    const val METHOD_PRINT_TEXT_TEST = "printTextTest"
    /**  =====Test=====  */

    const val METHOD_PRINT_GET_PRINTER = "printGetPrinter"
    const val METHOD_PRINT_LOG = "printSetLog"
    const val METHOD_PRINT_DESTROY = "printDestroy"
    const val METHOD_PRINT_START_SETTING = "printStartSetting"

    const val METHOD_QUERY_GET_STATUS = "queryGetStatus"
    const val METHOD_QUERY_GET_INFO = "queryGetInfo"

    const val METHOD_COMMAND_SEND_ESC = "commandSendEsc"
    const val METHOD_COMMAND_SEND_TSPL = "commandSendTspl"

    const val METHOD_LINE_INIT_LINE = "lineInitLine"
    const val METHOD_LINE_ADD_TEXT = "lineAddText"
    const val METHOD_LINE_PRINT_TEXT = "linePrintText"
    const val METHOD_LINE_PRINT_TEXTS = "linePrintTexts"
    const val METHOD_LINE_PRINT_BARCODE = "linePrintBarcode"
    const val METHOD_LINE_PRINT_QRCODE = "linePrintQrcode"
    const val METHOD_LINE_PRINT_BITMAP = "linePrintBitmap"
    const val METHOD_LINE_PRINT_DIVIDING_LINE = "linePrintDividingLine"
    const val METHOD_LINE_AUTO_OUT = "lineAutoOut"
    const val METHOD_LINE_ENABLE_TRANS_MODE = "lineEnableTransMode"
    const val METHOD_LINE_PRINT_TRANS = "linePrintTrans"

    const val METHOD_CANVAS_INIT_CANVAS = "canvasInitCanvas"
    const val METHOD_CANVAS_RENDER_TEXT = "canvasRenderText"
    const val METHOD_CANVAS_RENDER_BARCODE = "canvasRenderBarcode"
    const val METHOD_CANVAS_RENDER_QRCODE = "canvasRenderQrcode"
    const val METHOD_CANVAS_RENDER_BITMAP = "canvasRenderBitmap"
    const val METHOD_CANVAS_RENDER_AREA = "canvasRenderArea"
    const val METHOD_CANVAS_PRINT_CANVAS = "canvasPrintCanvas"

    const val METHOD_CASH_DRAWER_TO_OPEN = "cashDrawerToOpen"
    const val METHOD_CASH_DRAWER_IS_OPEN = "cashDrawerIsOpen"

}