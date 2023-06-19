class OneMessageModel {
  bool? result;
  Data? data;

  OneMessageModel({this.result, this.data});

  OneMessageModel.fromJson(Map<String, dynamic> json) {
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
  Message? message;

  Data({this.message});

  Data.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  int? id;
  String? role;
  String? message;
  dynamic sound;
  dynamic soundRatio;
  dynamic correctSentence;
  dynamic betterSentence;
  int? endConversation;
  String? createdTime;
  String? conversationCompletionCount;
  int? wordCount;

  Message(
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

  Message.fromJson(Map<String, dynamic> json) {
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
