class TranslateModel {
  bool? result;
  Data? data;

  TranslateModel({this.result, this.data});

  TranslateModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  TranslateMessage? message;

  Data({this.message});

  Data.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? TranslateMessage.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class TranslateMessage {
  int? id;
  String? role;
  String? message;
  String? sound;
  String? soundRatio;
  String? correctSentence;
  String? betterSentence;
  int? endConversation;
  String? createdTime;
  String? conversationCompletionCount;
  int? wordCount;

  TranslateMessage(
      {this.id,
      this.role,
      this.message,
      this.sound,
      this.soundRatio,
      this.correctSentence,
      this.betterSentence,
      this.endConversation,
      this.createdTime,
      this.conversationCompletionCount,
      this.wordCount});

  TranslateMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    message = json['message'];
    sound = json['sound'];
    soundRatio = json['sound_ratio'];
    correctSentence = json['correct_sentence'];
    betterSentence = json['better_sentence'];
    endConversation = json['end_conversation'];
    createdTime = json['created_time'];
    conversationCompletionCount = json['conversation_completion_count'];
    wordCount = json['word_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    data['message'] = message;
    data['sound'] = sound;
    data['sound_ratio'] = soundRatio;
    data['correct_sentence'] = correctSentence;
    data['better_sentence'] = betterSentence;
    data['end_conversation'] = endConversation;
    data['created_time'] = createdTime;
    data['conversation_completion_count'] = conversationCompletionCount;
    data['word_count'] = wordCount;
    return data;
  }
}
