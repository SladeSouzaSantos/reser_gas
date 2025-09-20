import 'package:flutter/material.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {    
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaSelecaoIdioma(),
    );
  }
}

class TelaSelecaoIdioma extends StatelessWidget {
  const TelaSelecaoIdioma({super.key});

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Selecione um idioma",
            style: TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontVariations: [
                FontVariation.weight(700),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ],
          ),
        ],
      ),
    );
  }

}