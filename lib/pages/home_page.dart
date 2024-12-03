import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/components/task_widget.dart';
import 'package:todo/pages/create_task/create_task.dart';
import 'package:todo/pages/cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..loadTasks(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[100],
          title: const Text('ToDo'),
          centerTitle: true,
         
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            print('Текущее состояние: $state');

            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskError) {
              return Center(child: Text(state.message));
            } else if (state is TaskLoaded) {
              final tasks = state.tasks;
              print('Задачи для отображения: $tasks');
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
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CreateTaskPage()),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
