import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class AppStrings {
  static  String appName = 'Changing'.tr();
  static  String home = 'الرئيسية';
  static  String Ads = 'Ads'.tr();
  static  String Service = 'Service'.tr();
  static  String Referrals = 'Referrals'.tr();
  static  String profile = 'Profile'.tr();
  static  String settings = 'Settings'.tr();
  static  String notifications = 'Notifications'.tr();

  static  String next = 'Next'.tr();
  static  String done = 'Done'.tr();
  static  String skip = 'Skip'.tr();
}

Future launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
  } else {
    print("Can't Launch $url");
  }
}