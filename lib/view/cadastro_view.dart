import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/cadastro_controller.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final ctrl = GetIt.I.get<CadastroController>();
  final txtConfirmaSenha = TextEditingController();

  void _validarCadastro() async {
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

    try {
      // Criação do usuário no Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: senha);

      // Salvar dados adicionais no Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
            'nome': nome,
            'email': email,
            'telefone': telefone,
            'uid': userCredential.user!.uid,
            'criadoEm': FieldValue.serverTimestamp(),
          });

      _mostrarMensagem('Cadastro realizado com sucesso!');
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushNamed(context, 'login');
      });
    } on FirebaseAuthException catch (e) {
      _mostrarMensagem('Erro ao cadastrar: ${e.message}');
    } catch (e) {
      _mostrarMensagem('Erro inesperado: $e');
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  void initState() {
    super.initState();
    ctrl.txtNome.clear();
    ctrl.txtEmail.clear();
    ctrl.txtTelefone.clear();
    ctrl.txtSenha.clear();
    txtConfirmaSenha.clear();
    ctrl.setAceitarTermos(false);
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
