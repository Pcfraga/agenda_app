import 'package:flutter/material.dart';
import 'package:agenda_app/database/database_helper.dart';

class EditScreen extends StatefulWidget {
  final int tarefaId;
  final String tarefaTitle;
  final String tarefaDate;
  final String tarefaTime;
  final String tarefaDescription;
  final DatabaseHelper databaseHelper;

  const EditScreen({
    super.key,
    required this.tarefaId,
    required this.tarefaTitle,
    required this.tarefaDate,
    required this.tarefaTime,
    required this.tarefaDescription,
    required this.databaseHelper,
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.tarefaTitle);
    _dateController = TextEditingController(text: widget.tarefaDate);
    _timeController = TextEditingController(text: widget.tarefaTime);
    _descriptionController = TextEditingController(text: widget.tarefaDescription);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      final updatedTask = {
        'title': _titleController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'description': _descriptionController.text,
      };

      int rowsUpdated = await widget.databaseHelper.updateTask(widget.tarefaId, updatedTask);

      if (rowsUpdated > 0) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar a tarefa!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarefa', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 20, 3, 176),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTask,
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 19, 4, 152),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Data',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Hora',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
