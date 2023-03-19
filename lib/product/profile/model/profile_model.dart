class ProfileModel {
  bool? result;
  Data? data;

  ProfileModel({this.result, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
  User? user;

  Data({this.user});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  NativeLanguage? nativeLanguage;
  List<LearnLanguages>? learnLanguages;
  String? profilePhoto;
  List<int>? color;
  DailyPractice? dailyPractice;

  User(
      {this.id,
      this.name,
      this.email,
      this.nativeLanguage,
      this.learnLanguages,
      this.profilePhoto,
      this.color,
      this.dailyPractice});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    nativeLanguage = json['native_language'] != null
        ? NativeLanguage.fromJson(json['native_language'])
        : null;
    if (json['learn_languages'] != null) {
      learnLanguages = <LearnLanguages>[];
      json['learn_languages'].forEach((v) {
        learnLanguages!.add(LearnLanguages.fromJson(v));
      });
    }
    profilePhoto = json['profile_photo'];
    color = json['color'].cast<int>();
    dailyPractice = json['daily_practice'] != null
        ? DailyPractice.fromJson(json['daily_practice'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    if (nativeLanguage != null) {
      data['native_language'] = nativeLanguage!.toJson();
    }
    if (learnLanguages != null) {
      data['learn_languages'] = learnLanguages!.map((v) => v.toJson()).toList();
    }
    data['profile_photo'] = profilePhoto;
    data['color'] = color;
    if (dailyPractice != null) {
      data['daily_practice'] = dailyPractice!.toJson();
    }
    return data;
  }
}

class NativeLanguage {
  int? id;
  String? code;
  String? title;
  String? flag;
  int? isPopular;

  NativeLanguage({this.id, this.code, this.title, this.flag, this.isPopular});

  NativeLanguage.fromJson(Map<String, dynamic> json) {
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

class LearnLanguages {
  int? id;
  String? code;
  String? title;
  String? flag;
  int? isPopular;
  ProficiencyLevel? proficiencyLevel;

  LearnLanguages(
      {this.id,
      this.code,
      this.title,
      this.flag,
      this.isPopular,
      this.proficiencyLevel});

  LearnLanguages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    title = json['title'];
    flag = json['flag'];
    isPopular = json['is_popular'];
    proficiencyLevel = json['proficiency_level'] != null
        ? ProficiencyLevel.fromJson(json['proficiency_level'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['title'] = title;
    data['flag'] = flag;
    data['is_popular'] = isPopular;
    if (proficiencyLevel != null) {
      data['proficiency_level'] = proficiencyLevel!.toJson();
    }
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

class DailyPractice {
  String? count;
  String? completionPercentage;

  DailyPractice({this.count, this.completionPercentage});

  DailyPractice.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    completionPercentage = json['completion_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['completion_percentage'] = completionPercentage;
    return data;
  }
}
