class TopicModel {
  bool? result;
  Data? data;

  TopicModel({this.result, this.data});

  TopicModel.fromJson(Map<String, dynamic> json) {
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
  List<Topics>? topics;

  Data({this.topics});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['topics'] != null) {
      topics = <Topics>[];
      json['topics'].forEach((v) {
        topics!.add(Topics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (topics != null) {
      data['topics'] = topics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Topics {
  int? id;
  String? title;
  String? icon;
  List<String>? description;

  Topics({this.id, this.title, this.icon, this.description});

  Topics.fromJson(Map<String, dynamic> json) {
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
