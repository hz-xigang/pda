/// 配件查询枚举
enum AccessoryInfo {
  ID,        // 硬件序列号
  NAME,      // 配件名称
  VERSION,   // 配件固件版本号
  NULL;      // 空值

  // 匹配对应的枚举类型
  static AccessoryInfo findInfo(String info) {
    return AccessoryInfo.values.firstWhere(
          (_info) => _info.toString().split('.').last == info,
      orElse: () => AccessoryInfo.NULL,
    );
  }
}
