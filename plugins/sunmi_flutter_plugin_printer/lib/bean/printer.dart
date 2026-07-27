import '../../api/canvas_api.dart';
import '../../api/cash_drawer_api.dart';
import '../../api/command_api.dart';
import '../../api/impl/canvas_api_impl.dart';
import '../../api/impl/cash_drawer_api_impl.dart';
import '../../api/impl/command_api_impl.dart';
import '../../api/impl/line_api_impl.dart';
import '../../api/impl/query_api_impl.dart';
import '../../api/line_api.dart';
import '../../api/query_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'printer.g.dart';

@JsonSerializable(explicitToJson: true)
class Printer {
  final String? printerId;

  const Printer({
    this.printerId,
  });

  factory Printer.fromJson(Map<String, dynamic> json) =>
      _$PrinterFromJson(json);

  Map<String, dynamic> toJson() => _$PrinterToJson(this);

  /// 查询相关
  @JsonKey(includeToJson: false, includeFromJson: false)
  QueryApi get queryApi => QueryApiImpl.instance;

  /// 指令集
  @JsonKey(includeToJson: false, includeFromJson: false)
  CommandApi get commandApi => CommandApiImpl.instance;

  /// 热敏小票
  @JsonKey(includeToJson: false, includeFromJson: false)
  LineApi get lineApi => LineApiImpl.instance;

  /// 标签打印
  @JsonKey(includeToJson: false, includeFromJson: false)
  CanvasApi get canvasApi => CanvasApiImpl.instance;

  /// 钱箱控制
  @JsonKey(includeToJson: false, includeFromJson: false)
  CashDrawerApi get cashDrawerApi => CashDrawerApiImpl.instance;

}
