import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

@lazySingleton
class UrlLaunchService {
  Future<bool> canLaunchUrl(String url) => url_launcher.canLaunchUrl(Uri.parse(url));
  Future<bool> launchUrl(String url) => url_launcher.launchUrl(Uri.parse(url));
}
