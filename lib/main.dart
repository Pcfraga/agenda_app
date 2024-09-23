import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'screens/cadastro_screen.dart';
import 'screens/details_screen.dart';
import 'screens/login_screen.dart';
import 'screens/tarefas_screen.dart';
import 'screens/task_form_screen.dart';
import 'screens/edit_screen.dart'; // Adicione esta linha

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseHelper = DatabaseHelper();

  runApp(
    MyApp(databaseHelper: databaseHelper),
  );
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  const MyApp({super.key, required this.databaseHelper});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(databaseHelper: databaseHelper),
        '/cadastro': (context) => CadastroScreen(databaseHelper: databaseHelper),
        '/tarefas': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

          if (args == null) {
            return const Scaffold(
              body: Center(child: Text('Nenhum argumento foi fornecido para a tela de tarefas.')),
            );
          }

          final userId = args['userId'] as int?;
          if (userId == null || userId <= 0) {
            return const Scaffold(
              body: Center(child: Text('ID de usuário inválido.')),
            );
          }

          return TarefasScreen(databaseHelper: databaseHelper, userId: userId);
        },
        '/tarefaDetalhes': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

          if (args == null) {
            return const Scaffold(
              body: Center(child: Text('Nenhum argumento foi fornecido para a tela de detalhes.')),
            );
          }

          final int tarefaId = args['id'] as int;
          final String tarefaTitle = args['title'] ?? 'Sem título';
          final String tarefaDate = args['date'] ?? 'Sem data';
          final String tarefaTime = args['time'] ?? 'Sem hora';
          final String tarefaDescription = args['description'] ?? 'Sem descrição';
          final int userId = args['userId'] as int;

          return DetailsScreen(
            tarefaId: tarefaId,
            tarefaTitle: tarefaTitle,
            tarefaDate: tarefaDate,
            tarefaTime: tarefaTime,
            tarefaDescription: tarefaDescription,
            userId: userId,
            databaseHelper: databaseHelper,
          );
        },
        '/taskForm': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

          if (args == null) {
            return const Scaffold(
              body: Center(child: Text('Nenhum argumento foi fornecido para a tela de formulário de tarefa.')),
            );
          }

          final int userId = args['userId'] as int;
          return TaskFormScreen(
            userId: userId,
            databaseHelper: databaseHelper,
          );
        },
        '/editTask': (context) {  // Adicione esta rota
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

          if (args == null) {
            return const Scaffold(
              body: Center(child: Text('Nenhum argumento foi fornecido para a tela de edição.')),
            );
          }

          return EditScreen(
            tarefaId: args['id'] as int,
            tarefaTitle: args['title'] as String,
            tarefaDate: args['date'] as String,
            tarefaTime: args['time'] as String,
            tarefaDescription: args['description'] as String,
            databaseHelper: databaseHelper,
          );
        },
      },
    );
  }
}
