import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:image/image.dart' as imglib;
import 'package:watch_it/watch_it.dart';

import '../manager/sync_out_manager.dart';

class SyncOut extends StatelessWidget {
  @override
  build(context) {
    const size = 270;
    final Encode result = zx.encodeBarcode(
      contents: sl<SyncOutManager>().getJson(),
      params: EncodeParams(format: Format.qrCode, width: size, height: size, margin: 10, eccLevel: EccLevel.low),
    );

    if (!result.isValid || result.data == null) return const Text('Could not generate QR code');

    final img = imglib.Image.fromBytes(width: size, height: size, bytes: result.data!.buffer, numChannels: 1);
    return Image.memory(imglib.encodePng(img));
  }
}
