import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(TaskLoading());

  Future<void> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tasksJson = prefs.getString('tasks');

      if (tasksJson != null) {
        final List<dynamic> decodedTasks = jsonDecode(tasksJson);
        final tasks = decodedTasks
            .map((task) => Map<String, dynamic>.from(task))
            .toList();
        _sortTasks(tasks);
        emit(TaskLoaded(tasks));
      } else {
        emit(TaskLoaded([]));
      }
    } catch (e) {
      emit(TaskError('Ошибка при загрузке задач'));
    }
  }

  Future<void> addTask(String text, String deadline) async {
    try {
      final updatedTasks = List<Map<String, dynamic>>.from(
        (state is TaskLoaded) ? (state as TaskLoaded).tasks : [],
      );

      updatedTasks.add({'text': '$text (до $deadline)', 'isCompleted': false});

      emit(TaskLoaded(updatedTasks));

      await _saveTasks(updatedTasks);
    } catch (e) {
      emit(TaskError('Ошибка при добавлении задачи'));
    }
  }

  Future<void> deleteTask(int index) async {
    try {
      final updatedTasks = List<Map<String, dynamic>>.from(
          (state is TaskLoaded) ? (state as TaskLoaded).tasks : []);
      updatedTasks.removeAt(index);
      _sortTasks(updatedTasks);
      await _saveTasks(updatedTasks);
      emit(TaskLoaded(updatedTasks));
    } catch (e) {
      emit(TaskError('Ошибка при удалении задачи'));
    }
  }

  Future<void> toggleTask(int index) async {
    try {
      final updatedTasks = List<Map<String, dynamic>>.from(
          (state is TaskLoaded) ? (state as TaskLoaded).tasks : []);
      updatedTasks[index]['isCompleted'] = !updatedTasks[index]['isCompleted'];
      _sortTasks(updatedTasks);
      await _saveTasks(updatedTasks);
      emit(TaskLoaded(updatedTasks));
    } catch (e) {
      emit(TaskError('Ошибка при изменении состояния задачи'));
    }
  }

  void _sortTasks(List<Map<String, dynamic>> tasks) {
    tasks.sort((a, b) => a['isCompleted'] ? 1 : -1);
  }

  Future<void> _saveTasks(List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksJson =
        jsonEncode(tasks); 
    await prefs.setString(
        'tasks', tasksJson);
  }
}
