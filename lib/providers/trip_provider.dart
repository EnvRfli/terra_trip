import 'package:flutter/foundation.dart';
import '../models/activity_model.dart';
import '../models/day_model.dart';
import '../models/trip_model.dart';

class TripProvider extends ChangeNotifier {
  TripModel? _currentTrip;

  TripProvider() {
    _loadDummyData();
  }

  TripModel? get currentTrip => _currentTrip;

  void _loadDummyData() {
    // Generate dates for current month to match UI (e.g., October)
    final now = DateTime.now();
    final baseDate = DateTime(now.year, now.month, 16);

    final List<DayModel> dummyDays = [];
    
    // Create a week of dummy data around base date
    for (int i = -3; i <= 3; i++) {
      final date = baseDate.add(Duration(days: i));
      final List<ActivityModel> activities = [];
      
      // Add activities specifically for the 16th to match schedule screen
      if (i == 0) {
        activities.addAll([
          ActivityModel(
            id: 'a1',
            title: 'Jakarta\'s Date 🐟💞',
            subtitle: 'Melihat aquarium di Jakarta bersama ayang selama seharian penuh...',
            category: 'Liburan',
            startTime: DateTime(date.year, date.month, date.day, 8, 0),
            endTime: DateTime(date.year, date.month, date.day, 17, 0),
            estimatedCost: 5000000.0,
            status: ActivityStatus.finished,
          ),
          ActivityModel(
            id: 'a2',
            title: 'Jakarta\'s Date 🐟💞',
            subtitle: 'Melihat aquarium di Jakarta bersama ayang selama seharian penuh...',
            category: 'Liburan',
            startTime: DateTime(date.year, date.month, date.day, 8, 0),
            endTime: DateTime(date.year, date.month, date.day, 17, 0),
            estimatedCost: 5000000.0,
            status: ActivityStatus.ongoing,
          ),
          ActivityModel(
            id: 'a3',
            title: 'Jakarta\'s Date 🐟💞',
            subtitle: 'Melihat aquarium di Jakarta bersama ayang selama seharian penuh...',
            category: 'Liburan',
            startTime: DateTime(date.year, date.month, date.day, 8, 0),
            endTime: DateTime(date.year, date.month, date.day, 17, 0),
            estimatedCost: 5000000.0,
            status: ActivityStatus.canceled,
          ),
          ActivityModel(
            id: 'a4',
            title: 'Jakarta\'s Date 🐟💞',
            subtitle: 'Melihat aquarium di Jakarta bersama ayang selama seharian penuh...',
            category: 'Liburan',
            startTime: DateTime(date.year, date.month, date.day, 8, 0),
            endTime: DateTime(date.year, date.month, date.day, 17, 0),
            estimatedCost: 5000000.0,
            status: ActivityStatus.upcoming,
          ),
        ]);
      } else if (i == 1) {
        // Add a "Kencan" category for testing
        activities.add(
          ActivityModel(
            id: 'a5',
            title: 'Dinner Date 🍝',
            subtitle: 'Makan malam romantis...',
            category: 'Kencan',
            startTime: DateTime(date.year, date.month, date.day, 19, 0),
            endTime: DateTime(date.year, date.month, date.day, 21, 0),
            estimatedCost: 1000000.0,
            status: ActivityStatus.upcoming,
          )
        );
      }

      dummyDays.add(DayModel(id: 'd$i', date: date, activities: activities));
    }

    _currentTrip = TripModel(
      id: 't1',
      title: 'Jakarta Trip',
      startDate: dummyDays.first.date,
      endDate: dummyDays.last.date,
      totalBudget: 15000000.0,
      days: dummyDays,
    );
    notifyListeners();
  }

  // Example CRUD operations
  void addActivity(String dayId, ActivityModel newActivity) {
    if (_currentTrip == null) return;
    
    final days = List<DayModel>.from(_currentTrip!.days);
    final dayIndex = days.indexWhere((d) => d.id == dayId);
    if (dayIndex != -1) {
      final updatedActivities = List<ActivityModel>.from(days[dayIndex].activities)..add(newActivity);
      days[dayIndex] = days[dayIndex].copyWith(activities: updatedActivities);
      _currentTrip = _currentTrip!.copyWith(days: days);
      notifyListeners();
    }
  }

  void updateActivityStatus(String activityId, ActivityStatus newStatus) {
    if (_currentTrip == null) return;
    
    final days = List<DayModel>.from(_currentTrip!.days);
    for (int i = 0; i < days.length; i++) {
      final activityIndex = days[i].activities.indexWhere((a) => a.id == activityId);
      if (activityIndex != -1) {
        final updatedActivities = List<ActivityModel>.from(days[i].activities);
        updatedActivities[activityIndex] = updatedActivities[activityIndex].copyWith(status: newStatus);
        days[i] = days[i].copyWith(activities: updatedActivities);
        _currentTrip = _currentTrip!.copyWith(days: days);
        notifyListeners();
        return;
      }
    }
  }

  // Getters for specific views
  List<ActivityModel> getActivitiesForDate(DateTime date) {
    if (_currentTrip == null) return [];
    try {
      final day = _currentTrip!.days.firstWhere(
        (d) => d.date.year == date.year && d.date.month == date.month && d.date.day == date.day,
      );
      return day.activities;
    } catch (e) {
      return [];
    }
  }
}
