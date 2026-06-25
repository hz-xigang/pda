
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class AudioUtil {

  static final AudioPlayer _player = AudioPlayer()
    ..setPlayerMode(PlayerMode.lowLatency);

  static Future<void> play(String asset) async {

    // 中断当前播放
    await _player.stop();

    // 播放新音频
    await _player.play(
      AssetSource(asset),
    );
  }


  static Future<void> scanFail() async {
    await play("audio/scan-error.wav");
  }


  static Timer? _timer;
  /// 指定时间循环播放
  static Future<void> playLoopForDuration(
      String asset, {
        required Duration duration,
      }) async {

    // 停止旧的
    await _player.stop();
    _timer?.cancel();

    // 设置循环
    await _player.setReleaseMode(ReleaseMode.loop);

    // 开始播放
    await _player.play(AssetSource(asset));

    // 到时间停止
    _timer = Timer(duration, () async {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.release);
    });
  }

  static DateTime? _lastPlay;

  static Future<void> scanFailLoop({
    int dur = 6000
}) async {
    if (_lastPlay != null &&
        DateTime.now().difference(_lastPlay!) <
            const Duration(milliseconds: 500)) {
      return;
    }

    _lastPlay = DateTime.now();

    await playLoopForDuration(
      "audio/scan-error.wav",
      duration:  Duration(milliseconds: dur),
    );
  }

  static Future<void> stop() async {
    await _player.stop();
    await _player.setReleaseMode(ReleaseMode.release);
  }

}