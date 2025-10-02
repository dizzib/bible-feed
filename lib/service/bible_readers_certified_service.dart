import 'package:dartx/dartx.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '/model/bible_reader.dart';
import '/model/bible_readers.dart';
import 'platform_service.dart';

@lazySingleton
class BibleReadersCertifiedService {
  BibleReadersCertifiedService(PlatformService platformService, BibleReaders bibleReaders)
    : _certifiedBibleReaderList =
          bibleReaders
              .filter(
                (br) =>
                    (platformService.isAndroid && br.certifiedPlatforms.contains(TargetPlatform.android)) ||
                    (platformService.isIOS && br.certifiedPlatforms.contains(TargetPlatform.iOS)),
              )
              .toList();

  final List<BibleReader> _certifiedBibleReaderList;

  List<BibleReader> get certifiedBibleReaderList => _certifiedBibleReaderList;
}
