import 'package:agenda_app/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';

class CadastroScreen extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const CadastroScreen({
    super.key,
    required this.databaseHelper,
  });

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _repitaSenhaController = TextEditingController();

  Future<void> _cadastrarUsuario() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_senhaController.text != _repitaSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('As senhas não coincidem.')),
        );
        return;
      }

      final hashedPassword = BCrypt.hashpw(_senhaController.text, BCrypt.gensalt());

      await widget.databaseHelper.insertUser(
        _emailController.text,
        hashedPassword,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );

      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 52, 20, 235),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color.fromARGB(255, 20, 3, 176),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/logo.jpg',
                  height: 200,
                  width: 300,
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  label: 'Nome',
                  obscureText: false,
                  textInputAction: TextInputAction.next,
                  controller: _nomeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome';
                    }
                    return null;
                  },
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Email',
                  obscureText: false,
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um email';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Por favor, insira um email válido';
                    }
                    return null;
                  },
                  icon: Icons.email,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Senha',
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  controller: _senhaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha';
                    }
                    return null;
                  },
                  icon: Icons.lock,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Repita a Senha',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  controller: _repitaSenhaController,
                  validator: (value) {
                    if (value != _senhaController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                  icon: Icons.lock_outline,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _cadastrarUsuario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 88, 17, 212),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required bool obscureText,
    required TextInputAction textInputAction,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          obscureText: obscureText,
          textInputAction: textInputAction,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white),
            border: const UnderlineInputBorder(),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            contentPadding: const EdgeInsets.only(bottom: 10),
          ),
          validator: validator,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
