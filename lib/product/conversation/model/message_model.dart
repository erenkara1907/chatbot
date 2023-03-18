class Messages {
  int? id;
  String? role;
  String? message;
  int? endConversation;

  Messages({this.id, this.role, this.message, this.endConversation});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    message = json['message'];
    endConversation = json['end_conversation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    data['message'] = message;
    data['end_conversation'] = endConversation;
    return data;
  }
}
