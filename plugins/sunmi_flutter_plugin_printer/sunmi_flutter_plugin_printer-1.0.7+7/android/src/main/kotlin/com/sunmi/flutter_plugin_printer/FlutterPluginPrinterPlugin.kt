package com.sunmi.flutter_plugin_printer

import android.app.Activity
import android.content.Context
import android.graphics.BitmapFactory
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.sunmi.printerx.PrinterSdk
import com.sunmi.printerx.api.PrintResult
import com.sunmi.printerx.enums.DividingLine
import com.sunmi.printerx.enums.PrinterInfo
import com.sunmi.printerx.enums.SettingItem
import com.sunmi.printerx.style.AreaStyle
import com.sunmi.printerx.style.BarcodeStyle
import com.sunmi.printerx.style.BaseStyle
import com.sunmi.printerx.style.BitmapStyle
import com.sunmi.printerx.style.LabelStyle
import com.sunmi.printerx.style.QrStyle
import com.sunmi.printerx.style.TextStyle
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel

/** FlutterPluginPrinterPlugin */
class FlutterPluginPrinterPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler,
    ActivityAware {
    private val TAG = "PrinterPlugin"

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var channel: MethodChannel? = null
    private var context: Context? = null
    private var activity: Activity? = null

    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null

    private val gson by lazy { Gson() }

    /**
     * Android端持有操作的printer
     */
    private var mPrinter: PrinterSdk.Printer? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, Constants.METHOD_CHANNEL_NAME)
        channel?.setMethodCallHandler(this)

        eventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, Constants.EVENT_CHANNEL_NAME)
        eventChannel?.setStreamHandler(this)

        context = flutterPluginBinding.applicationContext
        LogUtils.d(TAG, "onAttachedToEngine: $flutterPluginBinding")
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        LogUtils.d(TAG, "onMethodCall: ${call.method}; ${gson.toJson(call.arguments)}")
        when (call.method) {
            /// Test
            Constants.METHOD_GET_PLATFORM_VERSION -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            /// Test
            Constants.METHOD_GET_MY_FIRST_CHANNEL_TEST -> {
                result.success("good good good")
            }
            /// Test
            Constants.METHOD_PRINT_TEXT_TEST -> {
                PrinterSdk.getInstance().getPrinter(context, object : PrinterSdk.PrinterListen {
                    override fun onDefPrinter(p0: PrinterSdk.Printer?) {
                        LogUtils.d(TAG, "onDefPrinter: $p0")
                        eventSink?.success(gson.toJson(p0))
                        p0?.lineApi()?.run {
                            LogUtils.d(TAG, "printText: inner")
                            initLine(BaseStyle.getStyle())
                            printText("这行内容将直接打印出", TextStyle.getStyle())
                            addText("不同风格的内容:", TextStyle.getStyle())
                            addText("加粗", TextStyle.getStyle().enableBold(true))
                            addText("下划线", TextStyle.getStyle().enableUnderline(true))
                            addText("删除线", TextStyle.getStyle().enableStrikethrough(true))
                            addText("倾斜", TextStyle.getStyle().enableItalics(true))
                            addText("\n", TextStyle.getStyle())
                            autoOut()
                        }
                    }

                    override fun onPrinters(p0: List<PrinterSdk.Printer?>?) {
                        LogUtils.d(TAG, "onDefPrinter: $p0")
                        eventSink?.success(gson.toJson(p0))
                    }
                })
            }

            Constants.METHOD_PRINT_GET_PRINTER -> {
                PrinterSdk.getInstance().getPrinter(context, object : PrinterSdk.PrinterListen {
                    override fun onDefPrinter(p0: PrinterSdk.Printer?) {
                        LogUtils.d(TAG, "getPrinter==>onDefPrinter: $p0")
                        mPrinter = p0
                        result.success(gson.toJson(p0 ?: ""))
                    }

                    override fun onPrinters(p0: List<PrinterSdk.Printer?>?) {
                    }
                })
            }

            Constants.METHOD_PRINT_LOG -> {
                val enable = call.argument<Boolean>(ParamConstants.ENABLE) == true
                val tag = call.argument<String>(ParamConstants.TAG)
                LogUtils.d(TAG, "log: $enable; $tag")
                PrinterSdk.getInstance().log(enable, tag)
            }

            Constants.METHOD_PRINT_DESTROY -> {
                PrinterSdk.getInstance().destroy()
            }

            Constants.METHOD_PRINT_START_SETTING -> {
                val item = call.arguments?.toString()
                if (errorActivityNull(result)) return
                val settingItem = try {
                    SettingItem.valueOf(item ?: "")
                } catch (_: Exception) {
                    SettingItem.ALL
                }
                val startRes = PrinterSdk.getInstance().startSettings(activity, settingItem)
                result.success(startRes)
            }

            Constants.METHOD_QUERY_GET_STATUS -> {
                if (errorPrinterNull(result)) return
                try {
                    val status = mPrinter!!.queryApi().status
                    result.success(status.code)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }

            }

            Constants.METHOD_QUERY_GET_INFO -> {
                if (errorPrinterNull(result)) return
                val infoReq = call.arguments?.toString() ?: ""
                try {
                    val info = mPrinter!!.queryApi().getInfo(PrinterInfo.findInfo(infoReq))
                    result.success(info)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_COMMAND_SEND_ESC -> {
                if (errorPrinterNull(result)) return
                val escReq = call.arguments as? ByteArray
                try {
                    mPrinter!!.commandApi().sendEscCommand(escReq)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_COMMAND_SEND_TSPL -> {
                if (errorPrinterNull(result)) return
                val escReq = call.arguments as? ByteArray
                try {
                    mPrinter!!.commandApi().sendTsplCommand(escReq)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_LINE_INIT_LINE -> {
                if (errorPrinterNull(result)) return
                try {
                    val req = call.arguments as? String
                    val baseStyle = gson.fromJson<BaseStyle>(req, BaseStyle::class.java)
                    mPrinter!!.lineApi().initLine(baseStyle)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_LINE_ADD_TEXT -> {
                if (errorPrinterNull(result)) return
                try {
                    val text = call.argument<String>(ParamConstants.TEXT)
                    val styleStr = call.argument<String>(ParamConstants.STYLE)
                    val textStyle = gson.fromJson<TextStyle>(styleStr, TextStyle::class.java)
                    mPrinter!!.lineApi().addText(text, textStyle)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_LINE_PRINT_TEXT -> {
                if (errorPrinterNull(result)) return
                try {
                    val text = call.argument<String>(ParamConstants.TEXT)
                    val styleStr = call.argument<String>(ParamConstants.STYLE)
                    val textStyle = gson.fromJson<TextStyle>(styleStr, TextStyle::class.java)
                    mPrinter!!.lineApi().printText(text, textStyle)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_LINE_PRINT_TEXTS -> {
                if (errorPrinterNull(result)) return
                try {
                    val textListStr = call.argument<String>(ParamConstants.TEXT_LIST)
                    val colsWidthArrListStr =
                        call.argument<String>(ParamConstants.COLS_WIDTH_ARR_LIST)
                    val styleListStr = call.argument<String>(ParamConstants.STYLE_LIST)

                    val typeListString = TypeToken.getParameterized(MutableList::class.java, String::class.java).type
                    val textArray = gson.fromJson<MutableList<String>>(
                        textListStr,
                        typeListString
                    )?.toTypedArray()

                    val typeListInt = TypeToken.getParameterized(MutableList::class.java, Integer::class.java).type
                    val closWidthArrArray = gson.fromJson<MutableList<Int>>(
                        colsWidthArrListStr,
                        typeListInt
                    )?.toIntArray()

                    val typeListTextStyle = TypeToken.getParameterized(MutableList::class.java, TextStyle::class.java).type
                    val styleArray = gson.fromJson<MutableList<TextStyle>>(
                        styleListStr,
                        typeListTextStyle
                    )?.toTypedArray()

                    mPrinter!!.lineApi().printTexts(textArray, closWidthArrArray, styleArray)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_LINE_PRINT_BARCODE -> {
                if (errorPrinterNull(result)) return
                try {
                    val text = call.argument<String>(ParamConstants.TEXT)
                    val styleStr = call.argument<String>(ParamConstants.STYLE)
                    val barcodeStyle =
                        gson.fromJson<BarcodeStyle>(styleStr, BarcodeStyle::class.java)
                    mPrinter!!.lineApi().printBarCode(text, barcodeStyle)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_LINE_PRINT_QRCODE -> {
                if (errorPrinterNull(result)) return
                try {
                    val text = call.argument<String>(ParamConstants.TEXT)
                    val styleStr = call.argument<String>(ParamConstants.STYLE)
                    val qrStyle = gson.fromJson<QrStyle>(styleStr, QrStyle::class.java)
                    mPrinter!!.lineApi().printQrCode(text, qrStyle)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_LINE_PRINT_BITMAP -> {
                if (errorPrinterNull(result)) return
                try {
                    val bitmapArray = call.argument(ParamConstants.BITMAP) as? ByteArray
                    val styleStr = call.argument<String>(ParamConstants.STYLE)
                    // 解析 Bitmap
                    val bitmap =
                        BitmapFactory.decodeByteArray(bitmapArray, 0, bitmapArray?.size ?: 0)
                    val bitmapStyle = gson.fromJson<BitmapStyle>(styleStr, BitmapStyle::class.java)
                    mPrinter!!.lineApi().printBitmap(bitmap, bitmapStyle)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_LINE_PRINT_DIVIDING_LINE -> {
                if (errorPrinterNull(result)) return
                try {
                    val offset = call.argument<Int>(ParamConstants.OFFSET) ?: 0
                    val styleStr = call.argument<String>(ParamConstants.STYLE) ?: ""
                    val lineStyle = DividingLine.valueOf(styleStr)
                    mPrinter!!.lineApi().printDividingLine(lineStyle, offset)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_LINE_AUTO_OUT -> {
                if (errorPrinterNull(result)) return
                try {
                    mPrinter!!.lineApi().autoOut()
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_LINE_ENABLE_TRANS_MODE -> {
                if (errorPrinterNull(result)) return
                val enable = call.argument<Boolean>(ParamConstants.ENABLE) == true
                try {
                    mPrinter!!.lineApi().enableTransMode(enable)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_LINE_PRINT_TRANS -> {
                if (errorPrinterNull(result)) return
                try {
                    mPrinter!!.lineApi().printTrans(object : PrintResult() {
                        override fun onResult(resultCode: Int, message: String?) {
                            val resultMap = mutableMapOf<String, Any?>()
                            resultMap[ParamConstants.CODE] = resultCode
                            resultMap[ParamConstants.MSG] = message
                            result.success(resultMap)
                        }
                    })
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_CANVAS_INIT_CANVAS -> {
                if (errorPrinterNull(result)) return
                try {
                    val styleStr = call.argument<String>(ParamConstants.STYLE)
                    val labelStyle = gson.fromJson<LabelStyle>(styleStr, LabelStyle::class.java)
                    LogUtils.d(
                        TAG,
                        "initCanvas=>${mPrinter!!.canvasApi()}; ${gson.toJson(labelStyle)}"
                    )
                    mPrinter!!.canvasApi().initCanvas(labelStyle)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_CANVAS_RENDER_TEXT -> {
                if (errorPrinterNull(result)) return
                try {
                    val text = call.argument<String>(ParamConstants.TEXT)
                    val styleStr = call.argument<String>(ParamConstants.STYLE)
                    val textStyle = gson.fromJson<TextStyle>(styleStr, TextStyle::class.java)
                    mPrinter!!.canvasApi().renderText(text, textStyle)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_CANVAS_RENDER_BARCODE -> {
                if (errorPrinterNull(result)) return
                try {
                    val text = call.argument<String>(ParamConstants.TEXT)
                    val styleStr = call.argument<String>(ParamConstants.STYLE)
                    val barcodeStyle =
                        gson.fromJson<BarcodeStyle>(styleStr, BarcodeStyle::class.java)
                    mPrinter!!.canvasApi().renderBarCode(text, barcodeStyle)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_CANVAS_RENDER_QRCODE -> {
                if (errorPrinterNull(result)) return
                try {
                    val text = call.argument<String>(ParamConstants.TEXT)
                    val styleStr = call.argument<String>(ParamConstants.STYLE)
                    val qrStyle = gson.fromJson<QrStyle>(styleStr, QrStyle::class.java)
                    mPrinter!!.canvasApi().renderQrCode(text, qrStyle)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_CANVAS_RENDER_BITMAP -> {
                if (errorPrinterNull(result)) return
                try {
                    val bitmapArray = call.argument(ParamConstants.BITMAP) as? ByteArray
                    val styleStr = call.argument<String>(ParamConstants.STYLE)
                    // 解析 Bitmap
                    val bitmap =
                        BitmapFactory.decodeByteArray(bitmapArray, 0, bitmapArray?.size ?: 0)
                    val bitmapStyle = gson.fromJson<BitmapStyle>(styleStr, BitmapStyle::class.java)
                    mPrinter!!.canvasApi().renderBitmap(bitmap, bitmapStyle)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_CANVAS_RENDER_AREA -> {
                if (errorPrinterNull(result)) return
                try {
                    val styleStr = call.argument<String>(ParamConstants.STYLE)
                    val areaStyle = gson.fromJson<AreaStyle>(styleStr, AreaStyle::class.java)
                    mPrinter!!.canvasApi().renderArea(areaStyle)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_CANVAS_PRINT_CANVAS -> {
                if (errorPrinterNull(result)) return
                try {
                    val count = call.argument<Int>(ParamConstants.COUNT) ?: 1
                    LogUtils.d(TAG, "printCanvas=>${mPrinter!!.canvasApi()}; $count")
                    mPrinter!!.canvasApi().printCanvas(count, object : PrintResult() {
                        override fun onResult(resultCode: Int, message: String?) {
                            LogUtils.d(TAG, "printCanvas=>onResult: $resultCode; $message")
                            val resultMap = mutableMapOf<String, Any?>()
                            resultMap[ParamConstants.CODE] = resultCode
                            resultMap[ParamConstants.MSG] = message
                            result.success(resultMap)
                        }
                    })
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_CASH_DRAWER_TO_OPEN -> {
                if (errorPrinterNull(result)) return
                try {
                    mPrinter!!.cashDrawerApi().open(object : PrintResult() {
                        override fun onResult(resultCode: Int, message: String?) {
                            val resultMap = mutableMapOf<String, Any?>()
                            resultMap[ParamConstants.CODE] = resultCode
                            resultMap[ParamConstants.MSG] = message
                            result.success(resultMap)
                        }
                    })
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }

            Constants.METHOD_CASH_DRAWER_IS_OPEN -> {
                if (errorPrinterNull(result)) return
                try {
                    val isOpen = mPrinter!!.cashDrawerApi().isOpen
                    result.success(isOpen)
                } catch (e: Exception) {
                    errorMsg(result, e.message)
                }
            }


            else -> result.notImplemented()
        }

    }

    private fun errorPrinterNull(result: Result): Boolean {
        if (mPrinter == null) {
            errorMsg(result, "mPrinter is null", "-1000001")
            return true
        }
        return false
    }

    private fun errorActivityNull(result: Result): Boolean {
        if (activity == null) {
            errorMsg(result, "activity is null", "-1000002")
            return true
        }
        return false
    }

    private fun errorMsg(result: Result, msg: String?, code: String = "-1000003") {
        result.error(code, msg ?: "msg is null", null)
    }

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        LogUtils.d(TAG, "EventChannel onListen: $arguments; $eventSink")
        this.eventSink = eventSink

    }

    override fun onCancel(arguments: Any?) {
        LogUtils.d(TAG, "EventChannel onCancel: $arguments")
        eventSink = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        LogUtils.d(TAG, "onDetachedFromEngine")
        channel?.setMethodCallHandler(null)
        eventChannel?.setStreamHandler(null)
    }

    override fun onAttachedToActivity(p0: ActivityPluginBinding) {
        LogUtils.d(TAG, "onAttachedToActivity: $p0")
        activity = p0.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        LogUtils.d(TAG, "onDetachedFromActivityForConfigChanges")
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {
        LogUtils.d(TAG, "onReattachedToActivityForConfigChanges: $p0")
        activity = p0.activity
    }

    override fun onDetachedFromActivity() {
        LogUtils.d(TAG, "onDetachedFromActivity")
        activity = null
    }


}
