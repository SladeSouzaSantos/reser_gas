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
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gas_in_oil.jpg'),
                fit: BoxFit.cover,
                opacity: 0.25,
              ),
            ),
          ),


          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 96.0,
            children: [
              const Text(
                "SELECIONE UM IDIOMA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontVariations: [
                    FontVariation.weight(900),
                  ],
                ),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16.0,            
                children: [

                  InkWell(
                    onTap: (){},
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    child: Center(
                      child: Image.asset('assets/images/brasil.png', height: 50.0, width: 50.0),
                    ),
                  ),

                  InkWell(
                    onTap: (){},
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    child: Center(
                      child: Image.asset('assets/images/estados-unidos.png', height: 50.0, width: 50.0),
                    ),
                  ),

                  InkWell(
                    onTap: (){},
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    child: Center(
                      child: Image.asset('assets/images/espanha.png', height: 50.0, width: 50.0),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

}