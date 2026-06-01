class AiPersonalizationModel {
  final String model;
  final String responseStyle;
  final String difficultyLevel;
  final String language;
  final String subjectFocusArea;

  AiPersonalizationModel({
    required this.model,
    required this.responseStyle,
    required this.difficultyLevel,
    required this.language,
    required this.subjectFocusArea,
  });

  factory AiPersonalizationModel.fromJson(Map<String, dynamic> json) {
    return AiPersonalizationModel(
      model: json['model']?.toString() ?? 'gpt-4o',
      responseStyle: json['response_sytel']?.toString() ?? 'concise',
      difficultyLevel: json['dificulty_level']?.toString() ?? 'beginner',
      language: json['language']?.toString() ?? 'english',
      subjectFocusArea: json['subject_focus_area']?.toString() ?? '',
    );
  }
}
