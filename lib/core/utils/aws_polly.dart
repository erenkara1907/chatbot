import 'package:audioplayers/audioplayers.dart';
import 'package:aws_polly/aws_polly.dart';
import 'package:flutter/foundation.dart';

class AwsPollyService with ChangeNotifier {
  String? _url;
  final player = AudioPlayer();
  final AwsPolly awsPolly = AwsPolly.instance(
    poolId: 'eu-central-1:1181333e-ae48-4be7-b186-38b8c8c535c5',
    region: AWSRegionType.EUCentral1,
  );

  bool isCompleted = true;
  int selectedIndex = -1;
  bool isSpeaking = false;

  changeSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future onLoadUrl(String text) async {
    try {
      _url = null;
      final url = await awsPolly.getUrl(
        input: text,
        voiceId: AWSPolyVoiceId.joey,
      );

      _url = url;
      isCompleted = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while getting URL: $e');
      }
    }
  }

  Future onPlay() async {
    try {
      if (_url == null) return;

      await player.setSourceUrl(_url!);

      player.play(UrlSource(_url!));
      isCompleted = true;
      isSpeaking = true;
      notifyListeners();
    } catch (e) {
      print('Error occurred while playing audio: $e');
    }
  }

  stop() {
    player.stop();
    print("giridi : $_url!");
    isCompleted = true;
    notifyListeners();
  }
}
