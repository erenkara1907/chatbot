import 'package:url_launcher/url_launcher.dart';

// class SocialMediaData {
//   static void openInstagramApp() async {
//     String url = "https://www.instagram.com";

//     if (await canLaunchUrl(Uri.parse('instagram://'))) {
//       await launchUrl(Uri.parse('instagram://user?username=erenkara1907'));
//     } else {
//       await launchUrl(Uri.parse(url));
//     }
//   }
// }

class SocialMediaData {
  static SocialMediaData? _instance;
  static SocialMediaData get instance {
    _instance ??= SocialMediaData._init();
    return _instance!;
  }

  SocialMediaData._init();

  void openInstagramApp() async {
    // String url = "https://www.instagram.com";

    // // if (await canLaunchUrl(Uri.parse('instagram://'))) {
    // //   print("girdi");
    // //   await launchUrl(Uri.parse('instagram://user?username=erenkara1907'));
    // // } else {
    // //   print("girdi 2");
    // //   await launchUrl(Uri.parse(url));
    // // }

    const urlApp = 'instagram://user?username=erenkara1907';
    const urlWeb = 'https://www.instagram.com/erenkara1907';

    if (await canLaunchUrl(Uri.parse(urlApp))) {
      await launchUrl(Uri.parse(urlApp));
    } else if (await canLaunchUrl(Uri.parse(urlWeb))) {
      await launchUrl(Uri.parse(urlWeb));
    } else {
      throw 'Could not launch $urlWeb';
    }
  }
}
