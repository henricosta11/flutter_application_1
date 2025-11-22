import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'task_list_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return _selectedDay != null &&
                    day.year == _selectedDay!.year &&
                    day.month == _selectedDay!.month &&
                    day.day == _selectedDay!.day;
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskListPage(selectedDate: selectedDay),
                  ),
                );
              },
              headerStyle: const HeaderStyle(formatButtonVisible: false),
              calendarStyle: const CalendarStyle(
                todayDecoration:
                BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
                selectedDecoration:
                BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Toque em um dia para ver/editar tarefas',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
