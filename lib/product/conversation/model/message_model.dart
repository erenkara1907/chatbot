class Messages {
  int? id;
  String? role;
  String? message;
  int? endConversation;
  dynamic sound;
  dynamic soundRatio;
  String? correctSentence;
  String? betterSentence;

  Messages({
    this.id,
    this.role,
    this.message,
    this.endConversation,
    this.sound,
    this.soundRatio,
    this.correctSentence,
    this.betterSentence,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    message = json['message'];
    endConversation = json['end_conversation'];
    sound = json['sound'];
    soundRatio = json['sound_ratio'];
    correctSentence = json['correct_sentence'];
    betterSentence = json['better_sentence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    data['message'] = message;
    data['end_conversation'] = endConversation;
    data['sound'] = sound;
    data['sound_ratio'] = soundRatio;
    return data;
  }
}
