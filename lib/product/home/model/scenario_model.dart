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
  String? icon;

  Scenarios(
      {this.id,
      this.category,
      this.title,
      this.assistantRole,
      this.userRole,
      this.scenario,
      this.openingSentence,
      this.icon});

  Scenarios.fromJson(Map<String, dynamic> json) {
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
