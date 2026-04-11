class LibraryNoteModel {
  final String id;
  final String subject;
  final String title;
  final String text;
  final String aiResponse;
  final String? folderId;
  final String createdAt;
  final String updatedAt;

  LibraryNoteModel({
    required this.id,
    required this.subject,
    required this.title,
    required this.text,
    required this.aiResponse,
    this.folderId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LibraryNoteModel.fromJson(Map<String, dynamic> json) {
    final folder = json['folder'];
    String? fid;
    if (folder is Map) {
      fid = folder['id']?.toString();
    } else if (folder is String) {
      fid = folder;
    }

    return LibraryNoteModel(
      id: json['id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      aiResponse: json['ai_response']?.toString() ?? '',
      folderId: fid,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}
