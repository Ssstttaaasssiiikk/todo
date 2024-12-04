import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarState(taskDates: {}));

  Future<void> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tasksJson = prefs.getString('tasks');
      final Map<DateTime, List<String>> taskDates = {};

      if (tasksJson != null) {
        final List<dynamic> decodedTasks = jsonDecode(tasksJson);

        for (var task in decodedTasks) {
          final text = task['text'];
          final deadlineString =
              RegExp(r'\(до (.*?)\)').firstMatch(text)?.group(1);

          if (deadlineString != null) {
            try {
              final deadline = DateTime.parse(deadlineString);
              final normalizedDate = DateTime(
                deadline.year,
                deadline.month,
                deadline.day,
              );
              taskDates.putIfAbsent(normalizedDate, () => []).add(text);
            } catch (e) {
              print('Ошибка парсинга даты: $e');
            }
          }
        }
      }

      emit(state.copyWith(taskDates: taskDates));
    } catch (e) {
      print('Ошибка загрузки задач: $e');
      emit(state.copyWith(taskDates: {}));
    }
  }

  void selectDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final tasksForDate = state.taskDates[normalizedDate] ?? [];
    emit(state.copyWith(
      selectedDay: normalizedDate,
      selectedTasks: tasksForDate,
    ));
  }
}
