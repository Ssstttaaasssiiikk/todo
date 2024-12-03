part of 'home_cubit.dart';

class HomeState {}

class TaskLoading extends HomeState {}

class TaskLoaded extends HomeState {
  final List<Map<String, dynamic>> tasks;

  TaskLoaded(this.tasks);
}

class TaskError extends HomeState {
  final String message;

  TaskError(this.message);
}
