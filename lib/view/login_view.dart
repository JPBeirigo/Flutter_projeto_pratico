import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final ctrl = GetIt.I.get<LoginController>();

  @override
void initState() {
  super.initState();

  ctrl.txtEmail.clear();
  ctrl.txtSenha.clear();

  ctrl.addListener(() => setState(() {}));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1B18), 
      appBar: AppBar(
        backgroundColor: Color(0xFF3E2C24),
        title: Text('Dark Sun',style: TextStyle(color: Colors.amber[200])),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 40,
                color: Colors.amber[200],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              'lib/assets/images/logo.png',
              height: 180,
            ),
            SizedBox(height: 30),
            TextField(
              controller: ctrl.txtEmail,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: TextStyle(fontSize: 18, color: Colors.amber),
                prefixIcon: Icon(Icons.person, color: Colors.amber),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: ctrl.txtSenha,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(fontSize: 18, color: Colors.amber),
                prefixIcon: Icon(Icons.lock, color: Colors.amber),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent),
                ),
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'esqueci_a_senha');
              },
              child: Text(
                "Esqueci a Senha",
                style: TextStyle(
                  color: Colors.amberAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Não tem uma conta?',
                  style: TextStyle(fontSize: 12, color: Colors.white70)),
              SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'cadastro');
                },
                child: Text(
                  "Registre-se aqui",
                  style: TextStyle(
                    color: Colors.amberAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ]),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final email = ctrl.txtEmail.text.trim();
                final senha = ctrl.txtSenha.text.trim();

                final emailValido = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                    .hasMatch(email);

                if (email.isEmpty || senha.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, preencha todos os campos.')),
                  );
                  return;
                }

                if (!emailValido) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Digite um e-mail válido.')),
                  );
                  return;
                }

                Navigator.pushNamed(context, 'home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[800],
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
