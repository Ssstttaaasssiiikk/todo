import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/pages/cubit/home_cubit.dart';
import 'package:todo/pages/home_page.dart';

class CreateTaskPage extends StatelessWidget {
  const CreateTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController taskController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (BuildContext context, HomeState state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        final String taskText = taskController.text.trim();
                        if (taskText.isNotEmpty) {
                          DateTime? deadline;

                          // Если выбрана только дата
                          if (selectedDate != null && selectedTime == null) {
                            deadline = DateTime(
                              selectedDate!.year,
                              selectedDate!.month,
                              selectedDate!.day,
                            );
                          }
                          // Если выбрано только время
                          else if (selectedDate == null && selectedTime != null) {
                            final now = DateTime.now();
                            deadline = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              selectedTime!.hour,
                              selectedTime!.minute,
                            );
                          }
                          // Если выбраны и дата, и время
                          else if (selectedDate != null && selectedTime != null) {
                            deadline = DateTime(
                              selectedDate!.year,
                              selectedDate!.month,
                              selectedDate!.day,
                              selectedTime!.hour,
                              selectedTime!.minute,
                            );
                          }

                          context.read<HomeCubit>().addTask(
                                taskText,
                                deadline?.toString() ?? "Без срока",
                              );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        }
                      },
                      child: const Text('Добавить задачу'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: const Text('Отменить'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
