
import 'package:flutter/material.dart';
import 'package:hortiflutter/services/user_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = TextEditingController();
  final senhaController = TextEditingController();
  

  bool loading = false;

  Future<void> fazerLogin() async {
    setState(() => loading = true);

    final user = await UserService.login(
      loginController.text,
      senhaController.text,
    );

    setState(() => loading = false);

    if (user != null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(nome: user.nome, userId: user.id!)),
      );
    } else {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text("Login inválido")));
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
              controller: loginController,
              decoration: const InputDecoration(labelText: "Login"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Senha"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : fazerLogin,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Entrar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text("Criar conta"),
            ),
          ],
        ),
      ),
    );
  }
}