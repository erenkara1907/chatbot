class TranslateModel {
  bool? result;
  Data? data;

  TranslateModel({this.result, this.data});

  TranslateModel.fromJson(Map<String, dynamic> json) {
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
  TranslateMessage? message;

  Data({this.message});

  Data.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? TranslateMessage.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class TranslateMessage {
  int? id;
  String? role;
  String? message;
  int? endConversation;
  String? createdTime;

  TranslateMessage(
      {this.id,
      this.role,
      this.message,
      this.endConversation,
      this.createdTime});

  TranslateMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    message = json['message'];
    endConversation = json['end_conversation'];
    createdTime = json['created_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    data['message'] = message;
    data['end_conversation'] = endConversation;
    data['created_time'] = createdTime;
    return data;
  }
}
