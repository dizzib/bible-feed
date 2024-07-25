import 'package:logger/logger.dart';

class SimplePrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    return [event.message.toString()];
  }
}

final log = Logger(printer: SimplePrinter());
