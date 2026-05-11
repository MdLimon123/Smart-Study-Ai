class ProfileBadgeModel {
  final String id;
  final String label;
  final String? description;

  ProfileBadgeModel({
    required this.id,
    required this.label,
    this.description,
  });

  factory ProfileBadgeModel.fromJson(Map<String, dynamic> json) {
    return ProfileBadgeModel(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? 'Badge',
      description: json['description']?.toString(),
    );
  }
}
