import 'package:agenda_app/database/database_helper.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final int tarefaId;
  final String tarefaTitle;
  final String tarefaDate;
  final String tarefaTime;
  final String tarefaDescription;
  final int userId;
  final DatabaseHelper databaseHelper;

  const DetailsScreen({
    super.key,
    required this.tarefaId,
    required this.tarefaTitle,
    required this.tarefaDate,
    required this.tarefaTime,
    required this.tarefaDescription,
    required this.userId,
    required this.databaseHelper,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Tarefa'),
        backgroundColor: const Color.fromARGB(255, 11, 8, 195),
        foregroundColor: Colors.white, // Define a cor do texto da AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 22, 6, 166), // Fundo azul
        padding: const EdgeInsets.all(16.0),
        child: Center( // Centraliza o conteúdo
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
            crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente
            children: [
              Text(
                'Título: $tarefaTitle',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Data: $tarefaDate',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Hora: $tarefaTime',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Descrição: $tarefaDescription',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
