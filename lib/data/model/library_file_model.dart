class LibraryFileModel {
  final String id;
  final String subject;
  final String title;
  final String fileUrl;
  final String originalFilename;
  final int fileSizeBytes;
  final String aiResponse;
  final String? folderId;
  final String createdAt;

  LibraryFileModel({
    required this.id,
    required this.subject,
    required this.title,
    required this.fileUrl,
    required this.originalFilename,
    required this.fileSizeBytes,
    required this.aiResponse,
    this.folderId,
    required this.createdAt,
  });

  factory LibraryFileModel.fromJson(Map<String, dynamic> json) {
    final folder = json['folder'];
    String? fid;
    if (folder is Map) {
      fid = folder['id']?.toString();
    } else if (folder is String) {
      fid = folder;
    }

    final sizeRaw = json['file_size_bytes'];
    int size = 0;
    if (sizeRaw is int) {
      size = sizeRaw;
    } else if (sizeRaw is num) {
      size = sizeRaw.toInt();
    }

    return LibraryFileModel(
      id: json['id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      fileUrl: json['file_url']?.toString() ?? '',
      originalFilename: json['original_filename']?.toString() ?? '',
      fileSizeBytes: size,
      aiResponse: json['ai_response']?.toString() ?? '',
      folderId: fid,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
