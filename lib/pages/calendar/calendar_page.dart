import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/pages/calendar/cubit/calendar_cubit.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarCubit()..loadTasks(),
      child: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          final selectedDay = state.selectedDay ?? DateTime.now();

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueGrey[100],
              title: const Text('Календарь'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: selectedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDay, day);
                  },
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  calendarFormat: CalendarFormat.month,
                  eventLoader: (date) {
                    final normalizedDate =
                        DateTime(date.year, date.month, date.day);
                    return state.taskDates[normalizedDate] ?? [];
                  },
                  calendarStyle: CalendarStyle(
                    markerDecoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.orange[300],
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    context.read<CalendarCubit>().selectDate(selectedDay);
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: state.selectedTasks.isEmpty
                      ? const Center(
                          child: Text(
                            'Нет задач на выбранную дату',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.selectedTasks.length,
                          itemBuilder: (context, index) {
                            final task = state.selectedTasks[index];
                            return ListTile(
                              title: Text(task),
                              leading: const Icon(Icons.check_circle_outline),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
