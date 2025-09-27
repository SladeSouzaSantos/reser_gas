import 'package:flutter/material.dart';
import 'package:resergas/src/selecao_idioma/presentation/tela_selecao_idioma.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaSelecaoIdioma(),
    );
  }
  
}