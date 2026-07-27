
import '../../listener/printer_listener.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class EventChannelPlatformInterface extends PlatformInterface  {
  EventChannelPlatformInterface({required super.token});

  Future<void> getPrinter(PrinterListener listener);

}