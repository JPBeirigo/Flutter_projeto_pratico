import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EsqueciASenhaView extends StatefulWidget {
  const EsqueciASenhaView({super.key});

  @override
  State<EsqueciASenhaView> createState() => _EsqueciSenhaViewState();
}

class _EsqueciSenhaViewState extends State<EsqueciASenhaView> {
  final txtEmail = TextEditingController();

  void _enviarEmailRecuperacao() async {
    final email = txtEmail.text.trim();
    final emailValido = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);

    if (email.isEmpty) {
      _mostrarMensagem('Por favor, preencha o campo de e-mail.');
      return;
    }

    if (!emailValido) {
      _mostrarMensagem('Digite um e-mail válido.');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _mostrarMensagem(
        'Se o e-mail informado estiver cadastrado, enviaremos um link para redefinir sua senha.',
      );

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context); // Volta para a tela de login
      });
    } catch (e) {
      _mostrarMensagem('Erro ao enviar e-mail. Verifique o endereço digitado.');
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Digite o e-mail associado à conta que deseja recuperar. Enviaremos um link para redefinir sua senha.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: txtEmail,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                labelStyle: TextStyle(fontSize: 18),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _enviarEmailRecuperacao,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Enviar link de recuperação'),
            ),
          ],
        ),
      ),
    );
  }
}
