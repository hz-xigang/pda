import 'dart:async';

import 'package:vibration/vibration.dart';

class HapticUtil {

  static Timer? _timer;

  static Future<void> error({
    int dur = 6000
  }) async
  {

    if (await Vibration.hasVibrator() ?? false) {

      int elapsed = 0;

      _timer?.cancel();

      _timer = Timer.periodic(
        const Duration(milliseconds: 100),
            (t) {
          elapsed += 100;

          Vibration.vibrate(duration: 300);

          if (elapsed >= dur) {
            t.cancel();
          }
        },
      );
    }
  }

  static void stop() {
    _timer?.cancel();
    _timer = null;
  }


}