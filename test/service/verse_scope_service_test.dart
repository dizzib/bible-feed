import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/verse_scopes.dart';
import 'package:bible_feed/service/verse_scope_service.dart';
import 'package:bible_feed/service/verse_scope_toggler_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';
import 'verse_scope_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<VerseScopes>(), MockSpec<VerseScopeTogglerService>()])
void main() {
  const testVerseScopes = {
    1: {1: 'ℵ_Aleph', 2: 'ℶ_Beth'},
    2: 3,
  };

  final mockVerseScopes = MockVerseScopes();
  final mockTogglerService = MockVerseScopeTogglerService();
  final testee = VerseScopeService(mockVerseScopes, mockTogglerService);

  parameterizedTest(
    'getNextVerse/getVerseScopeLabel:',
    [
      [null, true, 1, 1, 1, '', 'no verse scopes'],
      [testVerseScopes, false, 1, 1, 1, '', 'service disabled'],
      [testVerseScopes, true, 3, 1, 1, '', 'scope not applicable to chapter'],
      [testVerseScopes, true, 1, 1, 2, 'ℵ\u00A0Aleph', 'not at last verse in static scope'],
      [testVerseScopes, true, 2, 1, 3, 'to\u00A0verse\u00A02', 'not at last verse in calculated scope'],
      [testVerseScopes, true, 2, 3, 1, 'from\u00A0verse\u00A03', 'at last verse in calculated scope'],
    ],
    customDescriptionBuilder:
        (_, _, values) => 'when ${values[6]}, expect next verse=${values[4]}, label="${values[5]}"',
    (var verseScopes, bool isEnabled, int chapter, int verse, int expectNextVerse, String expectLabel, String desc) {
      when(mockTogglerService.isEnabled).thenReturn(isEnabled);
      when(mockVerseScopes['b1']).thenReturn(verseScopes);
      final state = FeedState(book: b1, chapter: chapter, verse: verse);
      expect(testee.getNextVerse(state), expectNextVerse);
      expect(testee.getVerseScopeLabel(state), expectLabel);
    },
  );
}
