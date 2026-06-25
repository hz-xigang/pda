package com.hz.xg.hz_xg_pda
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val PDA_CHANNEL = "pda_broadcast"
    private var pdaReceiver: BroadcastReceiver? = null
    private var methodChannel: MethodChannel? = null

    // 推荐：在符合 Flutter 生命周期的此方法中配置 Channel
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 1. 初始化并复用 MethodChannel
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PDA_CHANNEL)

        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "controlScanner" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    controlScanner(enabled)
                    result.success("Scanner " + if (enabled) "enabled" else "disabled")
                }
                else -> result.notImplemented()
            }
        }

        // 2. 初始化广播接收器
        pdaReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent == null) return

                val action = intent.action
                if (action == "my_broadcast_service") {
                    // 安全地获取字符串，如果为 null 则传空字符串或不发送
                    val data = intent.getStringExtra("scannerdata") ?: ""

                    // 3. 使用复用的 channel 发送数据给 Flutter
                    methodChannel?.invokeMethod("onBroadcastReceived", data)
                }
            }
        }

        // 4. 注册广播 (兼容 Android 14 及以上系统的导向安全要求)
        val filter = IntentFilter("my_broadcast_service")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(pdaReceiver, filter, Context.RECEIVER_EXPORTED)
        } else {
            registerReceiver(pdaReceiver, filter)
        }
    }

    // 控制扫描头的方法
    private fun controlScanner(enabled: Boolean) {
        val intent = Intent("com.android.scanner.ENABLED")
        intent.putExtra("enabled", enabled)
        sendBroadcast(intent)
    }

    // 5. 必须在销毁时注销广播，防止内存泄漏
    override fun onDestroy() {
        super.onDestroy()
        pdaReceiver?.let {
            unregisterReceiver(it)
        }
    }
}