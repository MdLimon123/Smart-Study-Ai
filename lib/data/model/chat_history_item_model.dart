class ChatHistoryItemModel {
  final String id;
  final String prompt;
  final String aiResponse;
  final String createdAt;

  ChatHistoryItemModel({
    required this.id,
    required this.prompt,
    required this.aiResponse,
    required this.createdAt,
  });

  factory ChatHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryItemModel(
      id: json['id']?.toString() ?? '',
      prompt: json['prompt']?.toString() ?? '',
      aiResponse: json['ai_response']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
