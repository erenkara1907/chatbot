class RateModel {
  bool? result;
  Data? data;

  RateModel({this.result, this.data});

  RateModel.fromJson(Map<String, dynamic> json) {
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
  List<Rates>? rates;

  Data({this.rates});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['rates'] != null) {
      rates = <Rates>[];
      json['rates'].forEach((v) {
        rates!.add(Rates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (rates != null) {
      data['rates'] = rates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rates {
  int? id;
  String? title;
  int? value;
  String? icon;

  Rates({this.id, this.title, this.value, this.icon});

  Rates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    value = json['value'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['value'] = value;
    data['icon'] = icon;
    return data;
  }
}
