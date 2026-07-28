import 'package:flutter/services.dart';
import '../../common/constants.dart';
import '../../common/global_utils.dart';
import '../../interface/event_channel_platform_interface.dart';
import '../../listener/printer_listener.dart';

class EventChannelPlatformImpl implements EventChannelPlatformInterface {
  final _eventChannel = const EventChannel(Constants.EVENT_CHANNEL_NAME);

  EventChannelPlatformImpl._internal() {
    _eventChannel.receiveBroadcastStream().listen((event) {
      GlobalUtils.logger.d("EventChannelPlatformImpl listen: $event");
    }, onDone: (){});
  }
  static final EventChannelPlatformImpl _instance = EventChannelPlatformImpl._internal();
  static EventChannelPlatformImpl get instance => _instance;


  @override
  Future<void> getPrinter(PrinterListener listener) async {
    ///TODO 全局？？？

  }

}