import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/components/task_widget.dart';
import 'package:todo/pages/cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..loadTasks(), // Загрузка задач при старте
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[100],
          title: const Text('ToDo'),
          centerTitle: true,
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskError) {
              return Center(child: Text(state.message));
            } else if (state is TaskLoaded) {
              final tasks = state.tasks;
              return tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'Задач нет',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return TaskWidget(
                            text: task['text'],
                            isCompleted: task['isCompleted'],
                            onDelete: () =>
                                context.read<HomeCubit>().deleteTask(index),
                            onToggle: () =>
                                context.read<HomeCubit>().toggleTask(index),
                          );
                        },
                      ),
                    );
            } else {
              return const Center(child: Text('Неизвестная ошибка'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          onPressed: () => _showAddTaskModal(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    final TextEditingController taskController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Новая задача',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  labelText: 'Введите задачу',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          selectedDate = pickedDate;
                        }
                      },
                      child: const Text('Выбрать дату'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          selectedTime = pickedTime;
                        }
                      },
                      child: const Text('Выбрать время'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final String taskText = taskController.text.trim();
                  if (taskText.isNotEmpty &&
                      selectedDate != null &&
                      selectedTime != null) {
                    final DateTime deadline = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );
                    context
                        .read<HomeCubit>()
                        .addTask(taskText, deadline.toString());
                    Navigator.pop(context);
                  }
                },
                child: const Text('Добавить задачу'),
              ),
            ],
          ),
        );
      },
    );
  }
}
