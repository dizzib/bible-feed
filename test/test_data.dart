import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/reading_list.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:injectable/injectable.dart';

const b0 = Book('b0', 'Book 0', 1);
const b1 = Book('b1', 'Book 1', 3);
var rl0 = ReadingList('rl0', 'Reading List 0', const [b0]);
var rl1 = ReadingList('rl1', 'Reading List 1', const [b0, b1]);

@test
@LazySingleton(as: PlatformService)
class TestPlatformService extends PlatformService {
  @override
  bool get isAndroid => false;

  @override
  bool get isIOS => true;
}
