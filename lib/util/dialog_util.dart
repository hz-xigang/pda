import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hz_xg_pda/app_routes.dart';
import 'package:hz_xg_pda/const/index.dart';

class DialogUtil {
  DialogUtil._();

  static BuildContext? get _currentContext =>
      AppRoutes.navigatorKey.currentContext;

  /// 模态确认对话框（支持异步等待返回值）
  /// [context] 可选，不传时自动使用全局 Navigator 上下文
  static Future<bool> showConfirmDialog({
    BuildContext? context,
    String title = '提示',
    required String content,
    String cancelText = '取消',
    String confirmText = '确定',
    TextStyle textStyle = ALERT_DIALOG_TITLE_STYLE,
    bool barrierDismissible = false,
  }) async {
    final ctx = context ?? _currentContext;
    if (ctx == null) {
      return false;
    }

    final bool? result = await showDialog<bool>(
      context: ctx,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => AlertDialog(
        title: Text(title, style: textStyle),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(cancelText),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// 单按钮提示框（Alert）
  /// [context] 可选，不传时自动使用全局 Navigator 上下文
  static Future<void> showAlert({
    BuildContext? context,
    String title = '提示',
    required String content,
    String confirmText = '确定',
    TextStyle textStyle = ALERT_DIALOG_TITLE_STYLE,
    bool barrierDismissible = false,
  }) async {
    final ctx = context ?? _currentContext;
    if (ctx == null) {
      return;
    }

    EasyLoading.dismiss();
    await showDialog<void>(
      context: ctx,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => AlertDialog(
        title: Text(title, style: textStyle),
        content: Text(content),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
