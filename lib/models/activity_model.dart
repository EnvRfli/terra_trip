enum ActivityStatus { upcoming, ongoing, finished, canceled }

class ActivityModel {
  final String id;
  final String title;
  final String subtitle;
  final String category; // 'Liburan', 'Kencan'
  final DateTime startTime;
  final DateTime endTime;
  final double estimatedCost;
  final ActivityStatus status;
  final List<String> subActivities;
  // memory optional

  ActivityModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.startTime,
    required this.endTime,
    required this.estimatedCost,
    required this.status,
    this.subActivities = const [],
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      category: json['category'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
      status: ActivityStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ActivityStatus.upcoming,
      ),
      subActivities: List<String>.from(json['subActivities'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'estimatedCost': estimatedCost,
      'status': status.name,
      'subActivities': subActivities,
    };
  }

  ActivityModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? category,
    DateTime? startTime,
    DateTime? endTime,
    double? estimatedCost,
    ActivityStatus? status,
    List<String>? subActivities,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      status: status ?? this.status,
      subActivities: subActivities ?? this.subActivities,
    );
  }
}
