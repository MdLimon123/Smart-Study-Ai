class ScanHistoryItemModel {
  final String id;
  final String subject;
  final String imageUrl;
  final String question;
  final String aiResponse;

  ScanHistoryItemModel({
    required this.id,
    required this.subject,
    required this.imageUrl,
    required this.question,
    required this.aiResponse,
  });

  factory ScanHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return ScanHistoryItemModel(
      id: json['id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      aiResponse: json['ai_response']?.toString() ?? '',
    );
  }
}
