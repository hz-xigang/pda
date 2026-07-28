import 'package:json_annotation/json_annotation.dart';

import '../enum/align.dart' show Align;
import '../enum/error_level.dart' show ErrorLevel;
import '../enum/rotate.dart' show Rotate;
import '../format/qr_format.dart' show QrFormat;

part 'qr_style.g.dart';

/// 二维码样式属性
@JsonSerializable(explicitToJson: true)
class QrStyle {
  final QrFormat qrFormat;
  /// JsonSerializable不能使用私有构造QrStyle._(this.qrFormat);
  QrStyle(this.qrFormat);

  factory QrStyle.fromJson(Map<String, dynamic> json) => _$QrStyleFromJson(json);
  Map<String, dynamic> toJson() => _$QrStyleToJson(this);

  /// 设置条码生成块大小
  QrStyle setDot(int size) {
    qrFormat.dotSize = size;
    return this;
  }

  /// 设置条码的纠错等级
  QrStyle setErrorLevel(ErrorLevel level) {
    qrFormat.errorLevel = level.index;
    return this;
  }

  /// 设置自定义宽度
  QrStyle setWidth(int width) {
    qrFormat.width = width;
    return this;
  }

  /// 设置自定义高度
  QrStyle setHeight(int height) {
    qrFormat.height = height;
    return this;
  }

  /// 设置二维码内容的 x 坐标
  QrStyle setPosX(int offset) {
    qrFormat.xOffset = offset;
    return this;
  }

  /// 设置二维码内容的 y 坐标
  QrStyle setPosY(int offset) {
    qrFormat.yOffset = offset;
    return this;
  }

  /// 指定旋转方向
  QrStyle setRotate(Rotate rotate) {
    qrFormat.rotate = rotate.index;
    return this;
  }

  /// 指定条码相对坐标的对齐位置
  QrStyle setAlign(Align align) {
    qrFormat.align = align.index;
    return this;
  }

  /// 返回 QrFormat 对象
  QrFormat format() {
    return qrFormat;
  }

  /// 返回当前样式属性对象
  static QrStyle getStyle() {
    return QrStyle(QrFormat(dotSize: 4, symbology: 1));
  }
}
