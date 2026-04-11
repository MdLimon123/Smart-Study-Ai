class LibraryFolderModel {
  final String id;
  final String name;
  final String createdAt;
  final String updatedAt;

  LibraryFolderModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LibraryFolderModel.fromJson(Map<String, dynamic> json) {
    return LibraryFolderModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}
