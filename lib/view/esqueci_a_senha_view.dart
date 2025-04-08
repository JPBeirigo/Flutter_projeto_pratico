import 'package:flutter/material.dart';

class EsqueciASenhaView extends StatefulWidget {
  const EsqueciASenhaView({super.key});

  @override
  State<EsqueciASenhaView> createState() => _EsqueciSenhaViewState();
}

class _EsqueciSenhaViewState extends State<EsqueciASenhaView> {
  final txtEmail = TextEditingController();

  void _enviarEmailRecuperacao() {
  final email = txtEmail.text.trim();
  final emailValido = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);

  if (email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Por favor, preencha o campo de e-mail.')),
    );
    return;
  }

  if (!emailValido) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Digite um e-mail válido.')),
    );
    return;
  }

  // Mensagem de sucesso com feedback claro
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Se o e-mail informado estiver cadastrado, enviaremos um link para redefinir sua senha.',
      ),
      duration: Duration(seconds: 3),
    ),
  );

  // Voltar para a tela de login após alguns segundos (opcional)
  Future.delayed(Duration(seconds: 3), () {
    Navigator.pop(context, 'login');
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recuperar Senha')),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            Text(
              'Digite o e-mail associado a conta de que deseja recuperar acesso, será enviado um link para redefinir a senha',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            TextField(
              controller: txtEmail,
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: TextStyle(fontSize: 18),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _enviarEmailRecuperacao,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Enviar link de recuperação'),
            ),
          ],
        ),
      ),
    );
  }
}
