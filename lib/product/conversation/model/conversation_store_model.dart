class ConversationStoreModel {
  bool? result;
  Data? data;

  ConversationStoreModel({this.result, this.data});

  ConversationStoreModel.fromJson(Map<String, dynamic> json) {
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
  Conversation? conversation;

  Data({this.conversation});

  Data.fromJson(Map<String, dynamic> json) {
    conversation = json['conversation'] != null
        ? Conversation.fromJson(json['conversation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (conversation != null) {
      data['conversation'] = conversation!.toJson();
    }
    return data;
  }
}

class Conversation {
  int? id;
  int? isActive;
  Topic? topic;
  Language? language;
  ProficiencyLevel? proficiencyLevel;
  String? lastMessage;
  String? createdTime;

  Conversation(
      {this.id,
      this.isActive,
      this.topic,
      this.language,
      this.proficiencyLevel,
      this.lastMessage,
      this.createdTime});

  Conversation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'];
    topic = json['topic'] != null ? Topic.fromJson(json['topic']) : null;
    language =
        json['language'] != null ? Language.fromJson(json['language']) : null;
    proficiencyLevel = json['proficiency_level'] != null
        ? ProficiencyLevel.fromJson(json['proficiency_level'])
        : null;
    lastMessage = json['last_message'];
    createdTime = json['created_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['is_active'] = isActive;
    if (topic != null) {
      data['topic'] = topic!.toJson();
    }
    if (language != null) {
      data['language'] = language!.toJson();
    }
    if (proficiencyLevel != null) {
      data['proficiency_level'] = proficiencyLevel!.toJson();
    }
    data['last_message'] = lastMessage;
    data['created_time'] = createdTime;
    return data;
  }
}

class Topic {
  int? id;
  String? title;
  String? icon;

  Topic({this.id, this.title, this.icon});

  Topic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['icon'] = icon;
    return data;
  }
}

class Language {
  int? id;
  String? code;
  String? title;
  String? flag;
  int? isPopular;

  Language({this.id, this.code, this.title, this.flag, this.isPopular});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    title = json['title'];
    flag = json['flag'];
    isPopular = json['is_popular'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['title'] = title;
    data['flag'] = flag;
    data['is_popular'] = isPopular;
    return data;
  }
}

class ProficiencyLevel {
  int? id;
  String? cefr;
  String? scale;
  String? title;

  ProficiencyLevel({this.id, this.cefr, this.scale, this.title});

  ProficiencyLevel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cefr = json['cefr'];
    scale = json['scale'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cefr'] = cefr;
    data['scale'] = scale;
    data['title'] = title;
    return data;
  }
}
