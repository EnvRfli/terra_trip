import 'activity_model.dart';

class DayModel {
  final String id;
  final DateTime date;
  final List<ActivityModel> activities;

  DayModel({
    required this.id,
    required this.date,
    this.activities = const [],
  });

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      activities: (json['activities'] as List<dynamic>?)
              ?.map((e) => ActivityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'activities': activities.map((e) => e.toJson()).toList(),
    };
  }

  DayModel copyWith({
    String? id,
    DateTime? date,
    List<ActivityModel>? activities,
  }) {
    return DayModel(
      id: id ?? this.id,
      date: date ?? this.date,
      activities: activities ?? this.activities,
    );
  }
}
