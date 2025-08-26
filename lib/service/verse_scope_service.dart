import 'package:injectable/injectable.dart';

import '/model/feed.dart';
import 'toggler_service.dart';

@lazySingleton
class VerseScopeService {
  final VerseScopeTogglerService _verseScopeTogglerService;

  VerseScopeService(this._verseScopeTogglerService);

  Map<int, String>? _verseScopeMap(Feed f) => f.state.book.verseScopeMaps?[f.state.chapter];

  int nextVerse(Feed f) {
    if (!_verseScopeTogglerService.isEnabled) return 1;
    final vsm = _verseScopeMap(f);
    if (vsm == null) return 1;
    final verses = vsm.keys.toList();
    final index = verses.indexOf(f.state.verse) + 1;
    if (index == verses.length) return 1;
    return verses[index];
  }

  String verseScopeName(Feed f) {
    if (!_verseScopeTogglerService.isEnabled) return '';
    final vsm = _verseScopeMap(f);
    if (vsm == null) return '';
    return vsm[f.state.verse]!.replaceAll('_', String.fromCharCode(0x00A0));
  }
}
