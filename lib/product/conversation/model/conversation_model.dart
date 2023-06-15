class ConversationModel {
  bool? result;
  Data? data;

  ConversationModel({this.result, this.data});

  ConversationModel.fromJson(Map<String, dynamic> json) {
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
  List<Conversations>? conversations;

  Data({this.conversations});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['conversations'] != null) {
      conversations = <Conversations>[];
      json['conversations'].forEach((v) {
        conversations!.add(Conversations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (conversations != null) {
      data['conversations'] = conversations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Conversations {
  int? id;
  int? isActive;
  Topic? topic;
  ScenarioConversation? scenario;
  Language? language;
  Language? nativeLanguage;
  ProficiencyLevel? proficiencyLevel;
  String? lastMessage;
  String? createdTime;
  String? conversationCompletionCount;
  String? conversationTime;

  Conversations(
      {this.id,
      this.isActive,
      this.topic,
      this.scenario,
      this.language,
      this.nativeLanguage,
      this.proficiencyLevel,
      this.lastMessage,
      this.createdTime,
      this.conversationCompletionCount,
      this.conversationTime});

  Conversations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'];
    topic = json['topic'] != null ? Topic.fromJson(json['topic']) : null;
    scenario =
        json['scenario'] != null ? ScenarioConversation.fromJson(json['scenario']) : null;
    language =
        json['language'] != null ? Language.fromJson(json['language']) : null;
    nativeLanguage = json['native_language'] != null
        ? Language.fromJson(json['native_language'])
        : null;
    proficiencyLevel = json['proficiency_level'] != null
        ? ProficiencyLevel.fromJson(json['proficiency_level'])
        : null;
    lastMessage = json['last_message'];
    createdTime = json['created_time'];
    conversationCompletionCount = json['conversation_completion_count'];
    conversationTime = json['conversation_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_active'] = isActive;
    if (topic != null) {
      data['topic'] = topic!.toJson();
    }
    if (scenario != null) {
      data['scenario'] = scenario!.toJson();
    }
    if (language != null) {
      data['language'] = language!.toJson();
    }
    if (nativeLanguage != null) {
      data['native_language'] = nativeLanguage!.toJson();
    }
    if (proficiencyLevel != null) {
      data['proficiency_level'] = proficiencyLevel!.toJson();
    }
    data['last_message'] = lastMessage;
    data['created_time'] = createdTime;
    data['conversation_completion_count'] = conversationCompletionCount;
    data['conversation_time'] = conversationTime;
    return data;
  }
}

class Topic {
  int? id;
  String? title;
  String? icon;
  List<String>? description;

  Topic({this.id, this.title, this.icon, this.description});

  Topic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    icon = json['icon'];
    description = json['description'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['icon'] = icon;
    data['description'] = description;
    return data;
  }
}

class ScenarioConversation {
  int? id;
  Category? category;
  String? title;
  String? assistantRole;
  String? userRole;
  String? scenario;
  String? openingSentence;
  String? icon;

  ScenarioConversation(
      {this.id,
      this.category,
      this.title,
      this.assistantRole,
      this.userRole,
      this.scenario,
      this.openingSentence,
      this.icon});

  ScenarioConversation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    title = json['title'];
    assistantRole = json['assistant_role'];
    userRole = json['user_role'];
    scenario = json['scenario'];
    openingSentence = json['opening_sentence'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['title'] = title;
    data['assistant_role'] = assistantRole;
    data['user_role'] = userRole;
    data['scenario'] = scenario;
    data['opening_sentence'] = openingSentence;
    data['icon'] = icon;
    return data;
  }
}

class Category {
  int? id;
  String? title;
  String? icon;

  Category({this.id, this.title, this.icon});

  Category.fromJson(Map<String, dynamic> json) {
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
