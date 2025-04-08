import 'package:flutter/material.dart';

class CadastroController extends ChangeNotifier{

  final txtNome = TextEditingController();
  final txtEmail = TextEditingController();
  final txtSenha = TextEditingController();
  final txtTelefone = TextEditingController();
  bool _aceitarTermos = false;

  bool get aceitarTermos => _aceitarTermos;

  void setAceitarTermos (valor) {
    _aceitarTermos = valor;
    notifyListeners();

  }

  void limpar () {
    txtNome.clear();
    txtEmail.clear();
    txtSenha.clear();
    txtTelefone.clear();
    _aceitarTermos = false;
    notifyListeners();
  }

}///