import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier{

  final txtEmail = TextEditingController();
  final txtSenha = TextEditingController();

  bool _aceitarTermos = false;

  bool get aceitarTermos => _aceitarTermos;

  void setAceitarTermos (valor) {
    _aceitarTermos = valor;
    notifyListeners();

  }

  void limpar () {
    txtSenha.clear();
    txtEmail.clear();
    _aceitarTermos = false;
    notifyListeners();
  }

}///