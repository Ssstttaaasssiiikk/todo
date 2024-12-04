part of 'calendar_cubit.dart';

class CalendarState {
  final DateTime? selectedDay;
  final List<String> selectedTasks;
  final Map<DateTime, List<String>> taskDates;

  CalendarState({
    this.selectedDay,
    this.selectedTasks = const [],
    required this.taskDates,
  });

  CalendarState copyWith({
    DateTime? selectedDay,
    List<String>? selectedTasks,
    Map<DateTime, List<String>>? taskDates,
  }) {
    return CalendarState(
      selectedDay: selectedDay ?? this.selectedDay,
      selectedTasks: selectedTasks ?? this.selectedTasks,
      taskDates: taskDates ?? this.taskDates,
    );
  }
}
