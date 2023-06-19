class ChatModel {
  final int id;
  final String message;
  final String role;
  final String conversationCompletionCount;
  final int endConversation;
  dynamic sound;
  dynamic soundRatio;
  dynamic correctSentence;
  dynamic betterSentence;

  ChatModel({
    required this.id,
    required this.message,
    required this.role,
    required this.conversationCompletionCount,
    required this.endConversation,
    required this.sound,
    required this.soundRatio,
    required this.correctSentence,
    required this.betterSentence,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        message: json['message'],
        role: json['role'],
        id: json['id'],
        conversationCompletionCount: json['conversation_completion_count'],
        endConversation: json['end_conversation'],
        betterSentence: json['better_sentence'] ?? "",
        correctSentence: json['correct_sentence']  ?? "",
        sound: json['sound'] ?? "",
        soundRatio: json['sound_ratio'] ?? "",
      );
}
