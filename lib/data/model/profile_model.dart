class ProfileModel {
  final String id;
  final String email;
  final String name;
  final String? imageUrl;
  final String? description;
  final int problemsSolved;
  final int studyMinutes;
  final int activeDays;
  final bool twoFactorEnabled;
  final List<dynamic> badges;
  final int level;
  final String? createdAt;
  final String? updatedAt;

  ProfileModel({
    required this.id,
    required this.email,
    required this.name,
    this.imageUrl,
    this.description,
    required this.problemsSolved,
    required this.studyMinutes,
    required this.activeDays,
    required this.twoFactorEnabled,
    required this.badges,
    required this.level,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      description: json['description']?.toString(),
      problemsSolved: _parseInt(json['problems_solved']),
      studyMinutes: _parseInt(json['study_minutes']),
      activeDays: _parseInt(json['active_days']),
      twoFactorEnabled: json['two_factor_enabled'] == true,
      badges: json['badges'] is List ? List<dynamic>.from(json['badges'] as List) : [],
      level: _parseInt(json['level']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  /// Public for merging API partial payloads (e.g. activity PATCH `data`).
  static int parseInt(dynamic v) => _parseInt(v);

  ProfileModel copyWith({
    int? studyMinutes,
    int? activeDays,
  }) {
    return ProfileModel(
      id: id,
      email: email,
      name: name,
      imageUrl: imageUrl,
      description: description,
      problemsSolved: problemsSolved,
      studyMinutes: studyMinutes ?? this.studyMinutes,
      activeDays: activeDays ?? this.activeDays,
      twoFactorEnabled: twoFactorEnabled,
      badges: badges,
      level: level,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// `study_minutes` → compact label for stats row (e.g. `2h`, `1h 31m`, `45m`, `0`).
  String get studyTimeLabel {
    if (studyMinutes <= 0) return '0';
    if (studyMinutes < 60) return '${studyMinutes}m';
    final h = studyMinutes ~/ 60;
    final m = studyMinutes % 60;
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }
}
