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
    const urlApp = 'instagram://user?username=talkios'; 
    const urlWeb = 'https://www.instagram.com/talkios';

    if (await canLaunchUrl(Uri.parse(urlApp))) {
      await launchUrl(Uri.parse(urlApp));
    } else if (await canLaunchUrl(Uri.parse(urlWeb))) {
      await launchUrl(Uri.parse(urlWeb));
    } else {
      throw 'Could not launch $urlWeb';
    }
  }

  void openLinkedInApp() async {
    const urlApp = 'linkedin://in/talkios-app-939382283';
    const urlWeb = 'https://www.linkedin.com/in/talkios-app-939382283';

    if (await canLaunchUrl(Uri.parse(urlApp))) {
      await launchUrl(Uri.parse(urlApp));
    } else if (await canLaunchUrl(Uri.parse(urlWeb))) {
      await launchUrl(Uri.parse(urlWeb));
    } else {
      throw 'Could not launch $urlWeb';
    }
  }

  void openTwitterApp() async {
    const urlApp = 'twitter://user?screen_name=Talkios';
    const urlWeb = 'https://www.twitter.com/Talkios';

    if (await canLaunchUrl(Uri.parse(urlApp))) {
      await launchUrl(Uri.parse(urlApp));
    } else if (await canLaunchUrl(Uri.parse(urlWeb))) {
      await launchUrl(Uri.parse(urlWeb));
    } else {
      throw 'Could not launch $urlWeb';
    }
  }

  void openThreadsApp() async {
    const urlApp = 'threads://user?username=@talkios';
    const urlWeb = 'https://www.threads.net/@talkios';

    if (await canLaunchUrl(Uri.parse(urlApp))) {
      await launchUrl(Uri.parse(urlApp));
    } else if (await canLaunchUrl(Uri.parse(urlWeb))) {
      await launchUrl(Uri.parse(urlWeb));
    } else {
      throw 'Could not launch $urlWeb';
    }
  }
}
