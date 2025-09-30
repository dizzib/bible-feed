import 'package:injectable/injectable.dart';

@lazySingleton
class DateTimeService {
  DateTime get now => DateTime.now();
}

