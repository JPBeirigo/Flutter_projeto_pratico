import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/cadastro_controller.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final ctrl = GetIt.I.get<CadastroController>();
  final txtConfirmaSenha = TextEditingController();

  void _validarCadastro() {
    final nome = ctrl.txtNome.text.trim();
    final email = ctrl.txtEmail.text.trim();
    final telefone = ctrl.txtTelefone.text.trim();
    final senha = ctrl.txtSenha.text;
    final confirmaSenha = txtConfirmaSenha.text;

    final emailValido = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
    final telefoneValido = RegExp(r'^\(?\d{2}\)?[\s-]?\d{4,5}-?\d{4}$').hasMatch(telefone);

    if (nome.isEmpty || email.isEmpty || telefone.isEmpty || senha.isEmpty || confirmaSenha.isEmpty) {
      _mostrarMensagem('Por favor, preencha todos os campos.');
      return;
    }

    if (!emailValido) {
      _mostrarMensagem('Digite um e-mail válido.');
      return;
    }

    if (!telefoneValido) {
      _mostrarMensagem('Digite um número de telefone válido.');
      return;
    }

    if (senha != confirmaSenha) {
      _mostrarMensagem('As senhas não coincidem.');
      return;
    }

    if (!ctrl.aceitarTermos) {
      _mostrarMensagem('Você precisa aceitar os termos de uso.');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Cadastro realizado com sucesso!')),
);

// Redireciona após um pequeno delay para o usuário ver a mensagem
Future.delayed(Duration(seconds: 1), () {
  Navigator.pushNamed(context, 'login');
});

  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    txtConfirmaSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: ctrl.txtNome,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: ctrl.txtEmail,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: ctrl.txtTelefone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Telefone'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: ctrl.txtSenha,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Senha'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: txtConfirmaSenha,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirme a senha'),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: ctrl.aceitarTermos,
                    onChanged: (value) {
                      ctrl.setAceitarTermos(value ?? false);
                    },
                  ),
                  Flexible(child: Text('Eu aceito os termos de uso')),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _validarCadastro,
                  child: Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
