class AvatarModel {
  bool? result;
  Data? data;

  AvatarModel({this.result, this.data});

  AvatarModel.fromJson(Map<String, dynamic> json) {
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
  List<Avatars>? avatars;

  Data({this.avatars});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['avatars'] != null) {
      avatars = <Avatars>[];
      json['avatars'].forEach((v) {
        avatars!.add(Avatars.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (avatars != null) {
      data['avatars'] = avatars!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Avatars {
  int? id;
  String? url;
  List<int>? color;

  Avatars({this.id, this.url, this.color});

  Avatars.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    color = json['color'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['color'] = color;
    return data;
  }
}
