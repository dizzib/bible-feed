import 'package:injectable/injectable.dart';

import '../service/deeplink_service.dart';
import '../service/toast_service.dart';
import '../view/_constants.dart';
import 'json_encoding_manager.dart';
import 'share_in_manager.dart';

@singleton
class DeepLinkInManager {
  final DeepLinkService _deepLinkService;
  final JsonEncodingManager _jsonEncodingManager;
  final ShareInManager _shareInManager;
  final ToastService _toastService;

  DeepLinkInManager(this._deepLinkService, this._jsonEncodingManager, this._shareInManager, this._toastService) {
    _deepLinkService.addListener(() {
      try {
        final queryKey = Constants.deeplinkQueryKey;
        final uri = _deepLinkService.uri;
        if (!uri.query.startsWith('$queryKey=')) {
          throw Exception('The querystring key "$queryKey" was not found');
        }
        final queryValue = uri.query.substring(queryKey.length + 1); // ignore: avoid-substring, no emojis
        final decodedJson = _jsonEncodingManager.decode(queryValue);
        _shareInManager.sync(decodedJson);
        _toastService.showOk('Success!');
      } catch (err) {
        _toastService.showError(err.toString());
      }
    });
  }
}
