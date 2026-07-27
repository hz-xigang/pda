package com.sunmi.flutter_plugin_printer

import android.util.Log
import io.flutter.BuildConfig


/**
 * Author: Dean
 * Time: 2025/7/18 16:24
 * Email: mengqi.wu01@sunmi.com
 */

object LogUtils {

    private val isDebug by lazy { BuildConfig.DEBUG }

    fun v(tag: String, msg: String) {
        if (!isDebug) return
        Log.v(tag, msg)
    }

    fun d(tag: String, msg: String) {
        if (!isDebug) return
        Log.d(tag, msg)
    }

    fun i(tag: String, msg: String) {
        if (!isDebug) return
        Log.i(tag, msg)
    }

    fun w(tag: String, msg: String) {
        if (!isDebug) return
        Log.w(tag, msg)
    }

    fun e(tag: String, msg: String) {
        if (!isDebug) return
        Log.e(tag, msg)
    }
}