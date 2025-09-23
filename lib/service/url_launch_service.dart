import 'package:injectable/injectable.dart';

@lazySingleton
class UrlLaunchService {
  Future<bool> canLaunchUrl(Uri uri) async => canLaunchUrl(uri);
  Future<bool> launchUrl(Uri uri) async => launchUrl(uri);
}
