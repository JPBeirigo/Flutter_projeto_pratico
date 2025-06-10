import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/cadastro_controller.dart';
import 'package:flutter_application_1/controller/login_controller.dart';
import 'package:flutter_application_1/view/cadastro_view.dart';
import 'package:flutter_application_1/view/esqueci_a_senha_view.dart';
import 'package:flutter_application_1/view/grimorio_view.dart';
import 'package:flutter_application_1/view/home_view.dart';
import 'package:flutter_application_1/view/inventario_view.dart';
import 'package:flutter_application_1/view/journal_view.dart';
import 'package:flutter_application_1/view/login_view.dart';
import 'package:flutter_application_1/view/personagem_view.dart';
import 'package:flutter_application_1/view/rolagem_dados_view.dart';
import 'package:flutter_application_1/view/sobre_view.dart';
import 'package:flutter_application_1/view/turn_order_view.dart';
import 'package:get_it/get_it.dart';
import 'firebase_options.dart';

final g = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  g.registerSingleton<CadastroController>(CadastroController());
  g.registerSingleton<LoginController>(LoginController());

  runApp(DevicePreview(
    builder: (context) => const MainApp(),
  ));
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',

       //Rotas de Navegação
      initialRoute: 'login',
      routes: {
        'home' :  (context) => const HomeView(),
        'cadastro' : (context) => const CadastroView(),
        'login' : (context) => const LoginView(),
        'esqueci_a_senha' : (context) => const EsqueciASenhaView(),
        'sobre' : (context) => const SobreView(),
        'personagem' : (context) => const PersonagemView(),
        'inventario' : (context) => const InventarioView(),
        'turn_order' : (context) => const TurnOrderView(),
        'grimorio' : (context) => const GrimorioView(),
        'dados' : (context) => const RolagemDadosView(),
        'journal' : (context) => const JournalView(),
          
      },
    ); 
  }
}
