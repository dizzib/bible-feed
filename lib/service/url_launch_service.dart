import 'package:injectable/injectable.dart';

@lazySingleton
class UrlLaunchService {
  Future<bool> canLaunchUrl(String url) async => canLaunchUrl(url);
  Future<bool> launchUrl(String url) async => launchUrl(url);
}
