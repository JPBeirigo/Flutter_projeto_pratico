import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroController extends ChangeNotifier {
  final txtNome = TextEditingController();
  final txtEmail = TextEditingController();
  final txtSenha = TextEditingController();
  final txtTelefone = TextEditingController();
  bool _aceitarTermos = false;

  bool get aceitarTermos => _aceitarTermos;

  void setAceitarTermos(valor) {
    _aceitarTermos = valor;
    notifyListeners();
  }

  void limpar() {
    txtNome.clear();
    txtEmail.clear();
    txtSenha.clear();
    txtTelefone.clear();
    _aceitarTermos = false;
    notifyListeners();
  }

  /// Criação de conta no Firebase
  Future<String?> criarContaFirebase() async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: txtEmail.text.trim(),
        password: txtSenha.text.trim(),
      );
      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      return e.message; // mensagem de erro
    }
  }
}
