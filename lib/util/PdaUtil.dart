import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:hz_xg_pda/const/index.dart';
import 'package:hz_xg_pda/util/AudioUtil.dart';

import 'HapticUtil.dart';

class PdaUtil {
  // 1. 私有构造函数与单例实例
  PdaUtil._internal() {
    _initMethodChannel();
  }
  static final PdaUtil _instance = PdaUtil._internal();
  factory PdaUtil() => _instance;

  // 2. 通道与流控制器
  static const MethodChannel _channel = MethodChannel('pda_broadcast');

  // 使用 .broadcast() 允许同时有多个地方监听（比如全局日志记录器 + 当前活动页面）
  final StreamController<String> _scanStreamController = StreamController<String>.broadcast();

  /// 3. 暴露给外部的只读广播流
  Stream<String> get onScanResult => _scanStreamController.stream;

  /// 4. 全局唯一的底层监听初始化
  void _initMethodChannel() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onBroadcastReceived') {
        final data = call.arguments;
        if (data is String) {
          // 收到原生数据，直接灌入流中，分发给所有订阅的页面
          _scanStreamController.add(data);
        } else {
          debugPrint('PdaUtil Error: Invalid argument type: ${data.runtimeType}');
        }
      }
    });
    debugPrint('PdaUtil: 全局唯一 MethodChannel 监听初始化成功。');
  }

  /// 5. 控制扫描头开关（静态/实例方法均可，这里保留静态方便调用）
  static Future<void> controlScanner(bool enabled) async {
    try {
      await _channel.invokeMethod('controlScanner', {'enabled': enabled});
    } on PlatformException catch (e) {
      debugPrint('PdaUtil Exception: ${e.message}');
    }
  }


  static Timer? _errorTimer;
  static bool _isDialogShowing = false;

  static Future<void> errorScan(BuildContext context,String msg) async {

    if (_isDialogShowing) return;
    _isDialogShowing = true;

    // 1. 关闭扫描头
    controlScanner(false);

    // 2. 启动音频 + 震动
    AudioUtil.scanFailLoop();
    HapticUtil.error(dur: 6000);

    // 3. 弹窗
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("提示",style: ALERT_DIALOG_TITLE_STYLE,),
          content:  Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                _stopError();
                Navigator.of(context).pop();
              },
              child: const Text("确认"),
            ),
          ],
        );
      },
    );

    // 4. 自动关闭（6秒）
    _errorTimer?.cancel();
    _errorTimer = Timer(const Duration(seconds: 6), () {
      _stopError();
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  static Future<void> _stopError() async {

    _errorTimer?.cancel();
    _errorTimer = null;

    AudioUtil.stop();      // 你需要加
    HapticUtil.stop();     // 如果是循环震动
    controlScanner(true);

    _isDialogShowing = false;
  }

}