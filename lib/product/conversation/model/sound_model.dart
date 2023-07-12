class SoundModel {
  String? voice;
  bool? converted;
  double? audioDuration;
  String? audioUrl;
  String? message;
  String? transcriptionId;

  SoundModel({
    this.voice,
    this.converted,
    this.audioDuration,
    this.audioUrl,
    this.message,
    this.transcriptionId,
  });

  SoundModel.fromJson(Map<String, dynamic> json) {
    voice = json['voice'];
    converted = json['converted'];
    audioDuration = json['audioDuration'];
    audioUrl = json['audioUrl'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['voice'] = voice;
    data['converted'] = converted;
    data['audioDuration'] = audioDuration;
    data['audioUrl'] = audioUrl;
    data['message'] = message;
    data['transcriptionId'] = transcriptionId;
    return data;
  }
}
