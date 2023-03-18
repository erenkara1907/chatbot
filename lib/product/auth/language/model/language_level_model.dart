class LanguageLevelModel {
  bool? result;
  Data? data;

  LanguageLevelModel({this.result, this.data});

  LanguageLevelModel.fromJson(Map<String, dynamic> json) {
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
  List<LanguageProficiencyLevels>? languageProficiencyLevels;

  Data({this.languageProficiencyLevels});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['language_proficiency_levels'] != null) {
      languageProficiencyLevels = <LanguageProficiencyLevels>[];
      json['language_proficiency_levels'].forEach((v) {
        languageProficiencyLevels!.add(LanguageProficiencyLevels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (languageProficiencyLevels != null) {
      data['language_proficiency_levels'] =
          languageProficiencyLevels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LanguageProficiencyLevels {
  int? id;
  String? cefr;
  String? scale;
  String? title;

  LanguageProficiencyLevels({this.id, this.cefr, this.scale, this.title});

  LanguageProficiencyLevels.fromJson(Map<String, dynamic> json) {
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
