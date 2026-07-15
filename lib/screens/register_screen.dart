import '../services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:io';

import '../models/user_model.dart';
import '../utils/cpf_validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final login = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();
  final nome = TextEditingController();
  final cpf = TextEditingController();
  final email = TextEditingController();
  final data = TextEditingController();

  File? imagem;

  final cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');

  Future<void> selecionarImagem() async {
    final picker = ImagePicker();
    final XFile? foto = await picker.pickImage(source: ImageSource.gallery);

    if (foto != null) {
      setState(() {
        imagem = File(foto.path);
      });
    }
  }

  void cadastrar() async {
    if (formKey.currentState!.validate()) {
      if (senha.text != confirmarSenha.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Senhas não conferem")));
        return;
      }

      final usuario = UserModel(
        login: login.text,
        senha: senha.text,
        nome: nome.text,
        cpf: cpf.text,
        email: email.text,
        dataNascimento: data.text,
        foto: imagem?.path,
      );

      bool sucesso = await UserService.register(usuario);

      if (sucesso) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cadastro realizado com sucesso")),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(const SnackBar(content: Text("Erro ao cadastrar")));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: selecionarImagem,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imagem != null ? FileImage(imagem!) : null,
                  child: imagem == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              campoPadrao(login, "Login", Icons.person),

              campoSenha(senha, "Senha"),
              campoSenha(confirmarSenha, "Confirmar Senha"),

              campoPadrao(nome, "Nome", Icons.badge),

              // CPF COM MÁSCARA E VALIDAÇÃO
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: cpf,
                  keyboardType: TextInputType.number,
                  inputFormatters: [cpfMask],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório";
                    }
                    if (!CPFValidator.validar(value)) {
                      return "CPF inválido";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "CPF",
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                ),
              ),

              campoEmail(email),

              campoPadrao(data, "Data de Nascimento", Icons.calendar_today),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: cadastrar,
                child: const Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  // CAMPOS PERSONALIZADOS


  Widget campoPadrao(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        validator: (value) =>
            value == null || value.isEmpty ? "Campo obrigatório" : null,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      ),
    );
  }

  Widget campoSenha(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Campo obrigatório";
          }
          if (value.length < 6) {
            return "Senha deve ter no mínimo 6 caracteres";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock),
        ),
      ),
    );
  }

  Widget campoEmail(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Campo obrigatório";
          }
          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
            return "Email inválido";
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: "Email",
          prefixIcon: Icon(Icons.email),
        ),
      ),
    );
  }
}