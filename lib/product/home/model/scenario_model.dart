class ScenarioModel {
  bool? result;
  Data? data;

  ScenarioModel({this.result, this.data});

  ScenarioModel.fromJson(Map<String, dynamic> json) {
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
  List<Scenarios>? scenarios;

  Data({this.scenarios});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['scenarios'] != null) {
      scenarios = <Scenarios>[];
      json['scenarios'].forEach((v) {
        scenarios!.add(Scenarios.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (scenarios != null) {
      data['scenarios'] = scenarios!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Scenarios {
  int? id;
  Category? category;
  String? title;
  String? assistantRole;
  String? userRole;
  String? scenario;
  String? openingSentence;
  String? photo;
  String? icon;
  String? conversationCompletedScenario;
  List<Levels>? levels;

  Scenarios(
      {this.id,
      this.category,
      this.title,
      this.assistantRole,
      this.userRole,
      this.scenario,
      this.openingSentence,
      this.photo,
      this.icon,
      this.conversationCompletedScenario,
      this.levels});

  Scenarios.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    title = json['title'];
    assistantRole = json['assistant_role'];
    userRole = json['user_role'];
    scenario = json['scenario'];
    openingSentence = json['opening_sentence'];
    photo = json['photo'];
    icon = json['icon'];
    conversationCompletedScenario = json['conversation_completed_scenario'];
    if (json['levels'] != null) {
      levels = <Levels>[];
      json['levels'].forEach((v) {
        levels!.add(Levels.fromJson(v));
      });
    }
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
    data['photo'] = photo;
    data['icon'] = icon;
    data['conversation_completed_scenario'] = conversationCompletedScenario;
    if (levels != null) {
      data['levels'] = levels!.map((v) => v.toJson()).toList();
    }
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

class Levels {
  int? id;
  String? cefr;
  String? scale;
  String? title;
  dynamic conversationId;
  String? conversationCompleted;

  Levels(
      {this.id,
      this.cefr,
      this.scale,
      this.title,
      this.conversationId,
      this.conversationCompleted});

  Levels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cefr = json['cefr'];
    scale = json['scale'];
    title = json['title'];
    conversationId = json['conversation_id'];
    conversationCompleted = json['conversation_completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cefr'] = cefr;
    data['scale'] = scale;
    data['title'] = title;
    data['conversation_id'] = conversationId;
    data['conversation_completed'] = conversationCompleted;
    return data;
  }
}
