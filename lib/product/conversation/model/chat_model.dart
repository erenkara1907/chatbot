class ChatModel {
  final int id;
  final String message;
  final String role;
  final String conversationCompletionCount;
  final int endConversation;

  ChatModel({
    required this.id,
    required this.message,
    required this.role,
    required this.conversationCompletionCount,
    required this.endConversation,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        message: json['message'],
        role: json['role'],
        id: json['id'],
        conversationCompletionCount: json['conversation_completion_count'],
        endConversation: json['end_conversation'],
      );
}
