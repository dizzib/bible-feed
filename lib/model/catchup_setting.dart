import 'package:injectable/injectable.dart';

import 'setting.dart';

@lazySingleton
class CatchupSetting extends Setting<bool> {
  @override
  bool get defaultValue => false;

  @override
  String get storeKeyFragment => 'catchup';

  @override
  String get title => 'Catch Up';

  @override
  String get subtitle => 'Show an alert if you miss a day, to encourage you to get back on track.';
}
