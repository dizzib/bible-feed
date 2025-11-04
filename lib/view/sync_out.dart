import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:watch_it/watch_it.dart';

import '_build_context_extension.dart';
import '../manager/deeplink_out_manager.dart';

class SyncOut extends StatelessWidget {
  @override
  build(BuildContext context) {
    return PrettyQrView.data(
      data: sl<DeepLinkOutManager>().getUrl(),
      decoration: PrettyQrDecoration(
        shape: PrettyQrSmoothSymbol(color: context.isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }
}
