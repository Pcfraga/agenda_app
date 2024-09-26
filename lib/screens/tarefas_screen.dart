import 'package:flutter/material.dart';
import 'package:agenda_app/database/database_helper.dart';

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({
    super.key,
    required this.userId,
    required this.databaseHelper,
  });

  final int userId;
  final DatabaseHelper databaseHelper;

  @override
  _TarefasScreenState createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  List<Map<String, dynamic>> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    try {
      final tarefas = await widget.databaseHelper.getTasks(widget.userId);
      print('Debug: Tarefas carregadas: $tarefas');
      setState(() {
        _tarefas = tarefas;
      });
    } catch (e) {
      _mostrarSnackBar('Erro ao carregar tarefas: $e');
    }
  }

  Future<void> _deletarTarefa(int id) async {
    try {
      await widget.databaseHelper.deleteTask(id);
      print('Debug: Tarefa com id $id deletada');
      _carregarTarefas();
    } catch (e) {
      _mostrarSnackBar('Erro ao deletar tarefa: $e');
    }
  }

  void _mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void _showDeleteConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você tem certeza que deseja excluir esta tarefa?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () {
                Navigator.of(context).pop();
                _deletarTarefa(id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Center(
      child: Text(
        'Tarefas',
        style: TextStyle(color: Colors.white), // Texto em branco
      ),
    ),
    backgroundColor: const Color.fromARGB(255, 14, 4, 115), // Fundo da AppBar
    iconTheme: const IconThemeData(color: Colors.white),
  ),
      body: Container(
        color: const Color.fromARGB(255, 19, 5, 144),
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _tarefas.length,
          itemBuilder: (context, index) {
            final tarefa = _tarefas[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  tarefa['title'] ?? 'Sem título',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Descrição: ${tarefa['description'] ?? 'Nenhuma descrição'}',
                ),
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/tarefaDetalhes',
                    arguments: {
                      'id': tarefa['id'],
                      'title': tarefa['title'],
                      'date': tarefa['date'],
                      'time': tarefa['time'],
                      'description': tarefa['description'],
                      'userId': widget.userId,
                    },
                  );
                  if (result == true) {
                    _carregarTarefas();
                  }
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      child: const Text(
                        'Editar',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          '/editTask',
                          arguments: {
                            'id': tarefa['id'],
                            'title': tarefa['title'],
                            'date': tarefa['date'],
                            'time': tarefa['time'],
                            'description': tarefa['description'],
                            'userId': widget.userId,
                          },
                        );
                        if (result == true) {
                          _carregarTarefas();
                        }
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Excluir',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, tarefa['id']);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            '/taskForm',
            arguments: {
              'userId': widget.userId,
            },
          );
          if (result == true) {
            print('Debug: Nova tarefa adicionada ou editada');
            _carregarTarefas();
          }
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.blue),
      ),
    );
  }
}
