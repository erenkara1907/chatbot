// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  bool result;
  Data data;

  CategoryModel({
    required this.result,
    required this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        result: json["result"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": data.toJson(),
      };
}

class Data {
  List<Categories> categories;

  Data({
    required this.categories,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        categories: List<Categories>.from(
            json["categories"].map((x) => Categories.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Categories {
  int id;
  String title;
  String icon;
  List<ScenariosOfCategory> scenarios;

  Categories({
    required this.id,
    required this.title,
    required this.icon,
    required this.scenarios,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json["id"],
        title: json["title"],
        icon: json["icon"],
        scenarios: List<ScenariosOfCategory>.from(
            json["scenarios"].map((x) => ScenariosOfCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "icon": icon,
        "scenarios": List<dynamic>.from(scenarios.map((x) => x.toJson())),
      };
}

class ScenariosOfCategory {
  int id;
  String title;
  String assistantRole;
  String userRole;
  String scenario;
  String openingSentence;
  String photo;
  String icon;
  String conversationCompletedScenario;
  List<Level> levels;

  ScenariosOfCategory({
    required this.id,
    required this.title,
    required this.assistantRole,
    required this.userRole,
    required this.scenario,
    required this.openingSentence,
    required this.photo,
    required this.icon,
    required this.conversationCompletedScenario,
    required this.levels,
  });

  factory ScenariosOfCategory.fromJson(Map<String, dynamic> json) =>
      ScenariosOfCategory(
        id: json["id"],
        title: json["title"],
        assistantRole: json["assistant_role"],
        userRole: json["user_role"],
        scenario: json["scenario"],
        openingSentence: json["opening_sentence"],
        photo: json["photo"],
        icon: json["icon"],
        conversationCompletedScenario: json["conversation_completed_scenario"],
        levels: List<Level>.from(json["levels"].map((x) => Level.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "assistant_role": assistantRole,
        "user_role": userRole,
        "scenario": scenario,
        "opening_sentence": openingSentence,
        "photo": photo,
        "icon": icon,
        "conversation_completed_scenario": conversationCompletedScenario,
        "levels": List<dynamic>.from(levels.map((x) => x.toJson())),
      };
}

class Level {
  int id;
  String cefr;
  String scale;
  String title;
  dynamic conversationId;
  String conversationCompleted;

  Level({
    required this.id,
    required this.cefr,
    required this.scale,
    required this.title,
    required this.conversationId,
    required this.conversationCompleted,
  });

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json["id"],
        cefr: json["cefr"]!,
        scale: json["scale"]!,
        title: json["title"]!,
        conversationId: json["conversation_id"],
        conversationCompleted: json["conversation_completed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cefr": cefrValues.reverse[cefr],
        "scale": scaleValues.reverse[scale],
        "title": titleValues.reverse[title],
        "conversation_id": conversationId,
        "conversation_completed": conversationCompleted,
      };
}

enum Cefr { A1, A2, B1, B2, C1, C2 }

final cefrValues = EnumValues({
  "A1": Cefr.A1,
  "A2": Cefr.A2,
  "B1": Cefr.B1,
  "B2": Cefr.B2,
  "C1": Cefr.C1,
  "C2": Cefr.C2
});

enum ConversationIdEnum { NULL }

final conversationIdEnumValues = EnumValues({"null": ConversationIdEnum.NULL});

enum Scale {
  BEGINNER,
  PRE_INDERMEDIATE,
  INDERMEDIATE,
  UPPER_INDERMEDIATE,
  ADVANCED,
  MASTERY
}

final scaleValues = EnumValues({
  "Advanced": Scale.ADVANCED,
  "Beginner": Scale.BEGINNER,
  "Indermediate": Scale.INDERMEDIATE,
  "Mastery": Scale.MASTERY,
  "Pre-Indermediate": Scale.PRE_INDERMEDIATE,
  "Upper-Indermediate": Scale.UPPER_INDERMEDIATE
});

enum Title {
  I_CAN_SAY_HELLO,
  I_CAN_TALK_ABOUT_MY_HOBBIES,
  I_CAN_TALK_ABOUT_MY_EDUCATIONAL_BACKGROUND,
  I_CAN_SHARE_MY_FUTURE_GOALS,
  I_CAN_WRITE_A_MOVIE_REVIEW,
  I_CAN_ANALYZE_SCIENTIFIC_AND_PHILOSOPHICAL_TOPICS_IN_DETAIL
}

final titleValues = EnumValues({
  "I can analyze scientific and philosophical topics in detail.":
      Title.I_CAN_ANALYZE_SCIENTIFIC_AND_PHILOSOPHICAL_TOPICS_IN_DETAIL,
  "I can say hello.": Title.I_CAN_SAY_HELLO,
  "I can share my future goals.": Title.I_CAN_SHARE_MY_FUTURE_GOALS,
  "I can talk about my educational background.":
      Title.I_CAN_TALK_ABOUT_MY_EDUCATIONAL_BACKGROUND,
  "I can talk about my hobbies.": Title.I_CAN_TALK_ABOUT_MY_HOBBIES,
  "I can write a movie review.": Title.I_CAN_WRITE_A_MOVIE_REVIEW
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
