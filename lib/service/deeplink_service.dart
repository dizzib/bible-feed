import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'toast_service.dart';

@lazySingleton
class DeepLinkService with ChangeNotifier {
  final ToastService _toastService;

  DeepLinkService(this._toastService) {
    AppLinks().uriLinkStream.listen(
      (uriIn) {
        uri = uriIn;
        notifyListeners();
      },
      onError: (err) {
        _toastService.showError(err.toString());
      },
    );
  }

  // ignore: avoid-late-keyword, guaranteed to be set before notifyListeners() is called
  late Uri uri;
}
