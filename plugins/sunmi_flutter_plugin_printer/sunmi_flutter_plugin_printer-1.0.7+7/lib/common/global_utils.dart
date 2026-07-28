
import 'package:logger/logger.dart';

class GlobalUtils {
  static var logger = Logger(filter: MyLoggerFilter());
}

class MyLoggerFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }

}