# Sunmi 打印插件构建失败问题修复

## 问题现象

添加 `sunmi_flutter_plugin_printer: ^1.0.7+7` 依赖后，运行 `flutter run` 或 `flutter build apk` 时报错：

```
FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':sunmi_flutter_plugin_printer:compileDebugKotlin'.
> Error while evaluating property 'friendPathsSet$kotlin_gradle_plugin_common'
   > Could not resolve all files for configuration ':sunmi_flutter_plugin_printer:debugCompileClasspath'.
      > Failed to transform flutter.jar to match attributes {artifactType=android-classes-jar}
         > File/directory does not exist: D:\env\fvm\default\bin\cache\artifacts\engine\android-arm\flutter.jar
```

## 根本原因

### 1. Flutter 3.x 架构变更

从 Flutter 3.0 开始，为了减少 APK 体积和提升性能，Flutter 在 **debug 模式**下默认不再生成 32位 ARM（`android-arm`）架构的引擎产物。

FVM 缓存目录 `D:\env\fvm\default\bin\cache\artifacts\engine\` 中只有：
- `android-arm-profile/` - 32位 ARM profile 模式
- `android-arm-release/` - 32位 ARM release 模式
- `android-arm64-profile/` - 64位 ARM profile 模式
- `android-arm64-release/` - 64位 ARM release 模式

**缺少** `android-arm/` debug 模式目录。

### 2. 插件依赖配置问题

`sunmi_flutter_plugin_printer` 插件从 pub.dev 下载的版本（1.0.7+7）在其 `android/build.gradle` 中硬编码了对 32位 ARM debug 产物的依赖：

```groovy
dependencies {
    compileOnly files("$flutterRoot/bin/cache/artifacts/engine/android-arm/flutter.jar")
    // ... 其他依赖
}
```

这行代码会在编译时尝试访问不存在的文件路径，导致构建失败。

### 3. Kotlin 增量编译缓存问题

项目位于 D 盘，但 Flutter pub cache 位于 C 盘，Kotlin 增量编译在处理跨驱动器的相对路径时会产生缓存错误：

```
Caused by: java.lang.IllegalArgumentException: this and base files have different roots: 
C:\Users\...\Pub\Cache\hosted\pub.flutter-io.cn\audioplayers_android-5.2.1\android\src\...
and D:\code\flutter\hz_xg_pda\android.
```

## 修复方案

### 步骤 1：使用本地插件版本

将插件复制到项目本地，使用已修复的版本（不含问题依赖行）：

```bash
cp -r "C:\Users\10334\AppData\Local\Pub\Cache\hosted\pub.flutter-io.cn\sunmi_flutter_plugin_printer-1.0.7+7" \
     plugins/sunmi_flutter_plugin_printer
```

修改 `pubspec.yaml`：

```yaml
dependencies:
  sunmi_flutter_plugin_printer:
    path: plugins/sunmi_flutter_plugin_printer  # 使用本地路径
```

本地版本的 `plugins/sunmi_flutter_plugin_printer/android/build.gradle` 已经移除了问题依赖行，不再引用 `android-arm/flutter.jar`。

### 步骤 2：配置 ABI 过滤器

在 `android/app/build.gradle.kts` 中添加 ABI 过滤器，明确只构建 64位架构：

```kotlin
defaultConfig {
    applicationId = "com.hz.xg.hz_xg_pda"
    minSdk = flutter.minSdkVersion
    targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
    ndk {
        abiFilters.addAll(listOf("arm64-v8a", "x86_64"))  // 只构建 64位架构
    }
}
```

**说明**：现代 Android 设备（包括商米打印设备）都支持 64位架构，不需要 32位支持。

### 步骤 3：禁用 Kotlin 增量编译

在 `android/gradle.properties` 中添加：

```properties
kotlin.incremental=false
```

这样可以避免跨驱动器路径导致的缓存问题。虽然会稍微降低编译速度，但能确保构建稳定性。

### 步骤 4：清理构建缓存

```bash
flutter clean
./android/gradlew -p android clean
./android/gradlew --stop  # 停止 Gradle daemon
flutter pub get
flutter build apk --debug
```

## 验证结果

执行 `flutter build apk --debug` 后成功输出：

```
Running Gradle task 'assembleDebug'...                             56.8s
√ Built build\app\outputs\flutter-apk\app-debug.apk
```

## 为什么现在可以工作了？

1. **移除问题依赖**：本地插件版本不再依赖不存在的 `android-arm/flutter.jar`
2. **架构对齐**：通过 ABI 过滤器明确只构建存在的 64位架构产物
3. **缓存稳定**：禁用增量编译避免了跨驱动器路径问题
4. **干净环境**：清理缓存确保没有残留的错误状态

## 后续注意事项

1. **不要升级插件版本**：保持使用本地版本，除非 pub.dev 上的新版本修复了这个问题
2. **版本控制**：将 `plugins/sunmi_flutter_plugin_printer/` 目录加入 Git 版本控制
3. **团队协作**：其他开发者 clone 项目后直接 `flutter pub get` 即可，无需额外配置
4. **Release 构建**：Release 模式不受此问题影响，因为 Flutter 3.x 仍然生成 `android-arm-release/` 产物

## 相关文件修改清单

- `pubspec.yaml` - 改用本地插件路径
- `android/app/build.gradle.kts` - 添加 ABI 过滤器
- `android/gradle.properties` - 禁用 Kotlin 增量编译
- `plugins/sunmi_flutter_plugin_printer/` - 本地插件副本（需加入版本控制）

## 技术背景

### Flutter 架构产物说明

Flutter 编译时需要引擎库文件（`flutter.jar`），不同架构和模式有不同的产物：

| 架构 | Debug | Profile | Release |
|------|-------|---------|---------|
| 32位 ARM (armeabi-v7a) | ❌ 不生成 | ✅ 生成 | ✅ 生成 |
| 64位 ARM (arm64-v8a) | ✅ 生成 | ✅ 生成 | ✅ 生成 |
| x86 | ❌ 不生成 | ✅ 生成 | ✅ 生成 |
| x86_64 | ✅ 生成 | ✅ 生成 | ✅ 生成 |

从 Flutter 3.0 开始，为了加速开发调试，debug 模式只生成 64位架构产物。

### Google Play 64位要求

自 2019年8月起，Google Play 要求所有新应用和应用更新必须支持 64位架构。因此只构建 64位架构不会影响应用分发。

---

**修复日期**: 2026-07-27  
**Flutter 版本**: 3.38.3  
**插件版本**: sunmi_flutter_plugin_printer 1.0.7+7
