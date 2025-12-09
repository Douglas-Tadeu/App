import 'package:flutter/material.dart';
import '../../../controllers/auth_controller.dart';
import '../../../models/login_dto.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool loading = false;

  Future<void> realizarLogin() async {
    setState(() => loading = true);

    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      setState(() => loading = false);
      return;
    }

    final usuario = await AuthController.instance.login(email, senha);

    setState(() => loading = false);

    if (usuario != null) {
      // LOGIN OK → Navega para a Home
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      // LOGIN FALHOU
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email ou senha incorretos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Senha"),
            ),
            const SizedBox(height: 24),

            // BOTÃO LOGIN
            ElevatedButton(
              onPressed: loading ? null : realizarLogin,
              child: loading
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Text("Entrar"),
            ),

            const SizedBox(height: 20),

            // IR PARA CADASTRO
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/cadastro");
              },
              child: const Text("Criar uma conta"),
            )
          ],
        ),
      ),
    );
  }
}
