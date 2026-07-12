import 'day_model.dart';

class TripModel {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final double totalBudget;
  final List<DayModel> days;
  final List<String> secretChecklist;

  TripModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.totalBudget,
    this.days = const [],
    this.secretChecklist = const [],
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      title: json['title'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalBudget: (json['totalBudget'] as num).toDouble(),
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => DayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      secretChecklist: List<String>.from(json['secretChecklist'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalBudget': totalBudget,
      'days': days.map((e) => e.toJson()).toList(),
      'secretChecklist': secretChecklist,
    };
  }

  TripModel copyWith({
    String? id,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    double? totalBudget,
    List<DayModel>? days,
    List<String>? secretChecklist,
  }) {
    return TripModel(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalBudget: totalBudget ?? this.totalBudget,
      days: days ?? this.days,
      secretChecklist: secretChecklist ?? this.secretChecklist,
    );
  }
}
