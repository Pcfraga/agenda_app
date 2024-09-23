import 'package:agenda_app/database/database_helper.dart';
import 'package:flutter/material.dart';

@immutable
class TaskFormScreen extends StatefulWidget {
  final int? taskId;
  final String? initialTitle;
  final String? initialDate;
  final String? initialTime;
  final String? initialDescription;
  final int userId;
  final DatabaseHelper databaseHelper;

  const TaskFormScreen({
    super.key,
    this.taskId,
    this.initialTitle,
    this.initialDate,
    this.initialTime,
    this.initialDescription,
    required this.userId,
    required this.databaseHelper,
  });

  @override
  TaskFormScreenState createState() => TaskFormScreenState();
}

class TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _dateController = TextEditingController(text: widget.initialDate ?? '');
    _timeController = TextEditingController(text: widget.initialTime ?? '');
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.taskId == null ? 'Adicionar Tarefa' : 'Editar Tarefa',
            style: TextStyle(color: Colors.white), // Texto em branco
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 17, 9, 174), // Fundo azul
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Data (YYYY-MM-DD)',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma data';
                    }
                    final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                    if (!datePattern.hasMatch(value)) {
                      return 'Formato de data inválido. Use YYYY-MM-DD.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: 'Hora (HH:MM)',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma hora';
                    }
                    final timePattern = RegExp(r'^\d{2}:\d{2}$');
                    if (!timePattern.hasMatch(value)) {
                      return 'Formato de hora inválido. Use HH:MM.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 88, 17, 212),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Salvar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState?.validate() ?? false) {
      final task = {
        'title': _titleController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'description': _descriptionController.text,
        'userId': widget.userId,
      };

      if (widget.taskId == null) {
        final id = await widget.databaseHelper.insertTask(task);
        print('Debug: Nova tarefa adicionada com id $id: $task');
      } else {
        await widget.databaseHelper.updateTask(widget.taskId!, task);
        print('Debug: Tarefa com id ${widget.taskId} atualizada: $task');
      }

      Navigator.pop(context, true);
    } else {
      print('Debug: Formulário inválido');
    }
  }
}
