class ScanResultModel {
  final String scanId;
  final String subject;
  final String aiResponse;

  ScanResultModel({
    required this.scanId,
    required this.subject,
    required this.aiResponse,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      scanId: json['scan_id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      aiResponse: json['ai_response']?.toString() ?? '',
    );
  }
}
