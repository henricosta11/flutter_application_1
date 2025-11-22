import 'package:flutter/material.dart';
import 'models/task.dart';
import 'services/storage_service.dart';

class TaskListPage extends StatefulWidget {
  final DateTime selectedDate;
  const TaskListPage({super.key, required this.selectedDate});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final StorageService _storage = StorageService();
  List<Task> _tasks = [];

  String get _dateKey => widget.selectedDate.toIso8601String().split('T').first;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await _storage.loadTasksFor(_dateKey);
    setState(() {
      _tasks = loaded;
      _sortTasks();
    });
  }

  Future<void> _save() async {
    await _storage.saveTasksFor(_dateKey, _tasks);
  }

  void _addTask(String title) {
    setState(() {
      _tasks.add(Task(title: title, isDone: false));
      _sortTasks();
    });
    _save();
  }

  void _toggleDone(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
      _sortTasks();
    });
    _save();
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _save();
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a.isDone == b.isDone) {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
      return a.isDone ? 1 : -1; // pendentes (isDone=false) primeiro
    });
  }

  void _showAddDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova Tarefa'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Digite a tarefa'),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
                onPressed: () {
                  final text = controller.text.trim();
                  if (text.isNotEmpty) _addTask(text);
                  Navigator.pop(context);
                },
                child: const Text('Adicionar')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = '${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}';
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas - $dateLabel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          )
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('Nenhuma tarefa. Toque + para adicionar.'))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final t = _tasks[index];
          return ListTile(
            leading: Checkbox(
              value: t.isDone,
              onChanged: (_) => _toggleDone(index),
            ),
            title: Text(
              t.title,
              style: TextStyle(
                decoration: t.isDone ? TextDecoration.lineThrough : null,
                color: t.isDone ? Colors.grey : null,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeTask(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
