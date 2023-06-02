class CategoryModel {
  bool? result;
  Data? data;

  CategoryModel({this.result, this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
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
  List<Categories>? categories;

  Data({this.categories});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? title;
  String? icon;
  List<ScenariosCategory>? scenarios;

  Categories({this.id, this.title, this.icon, this.scenarios});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    icon = json['icon'];
    if (json['scenarios'] != null) {
      scenarios = <ScenariosCategory>[];
      json['scenarios'].forEach((v) {
        scenarios!.add(ScenariosCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['icon'] = icon;
    if (scenarios != null) {
      data['scenarios'] = scenarios!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScenariosCategory {
  int? id;
  String? title;
  String? assistantRole;
  String? userRole;
  String? scenario;
  String? openingSentence;
  String? icon;

  ScenariosCategory(
      {this.id,
      this.title,
      this.assistantRole,
      this.userRole,
      this.scenario,
      this.openingSentence,
      this.icon});

  ScenariosCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    data['title'] = title;
    data['assistant_role'] = assistantRole;
    data['user_role'] = userRole;
    data['scenario'] = scenario;
    data['opening_sentence'] = openingSentence;
    data['icon'] = icon;
    return data;
  }
}
