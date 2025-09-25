import 'package:flutter/material.dart';


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

class TelaSelecaoIdioma extends StatefulWidget {
  const TelaSelecaoIdioma({super.key});

  @override
  State<TelaSelecaoIdioma> createState() => _TelaSelecaoIdiomaState();
}

class _TelaSelecaoIdiomaState extends State<TelaSelecaoIdioma> {
  
  static const Map<String, String> _traducoes = {
    'Português': 'SELECIONE UM IDIOMA',
    'Inglês': 'SELECT A LANGUAGE',
    'Espanhol': 'SELECCIONA UN IDIOMA',
  };

  static const Map<String, String> _traducoesBotao = {
    'Português': 'Confirmar Seleção',
    'Inglês': 'Confirm Selection',
    'Espanhol': 'Confirmar Selección',
  };

  String? _idiomaSelecionado;

  @override
  void initState() {
    super.initState();
    _idiomaSelecionado = 'Português';
  }

  void _selecionarIdioma(String idioma) {
    setState(() {
      _idiomaSelecionado = idioma;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/solo_formation.jpg'),
                fit: BoxFit.cover,
                opacity: 1.0,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _traducoes[_idiomaSelecionado] ?? _traducoes['Português']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 96.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PaisButtonWidget(
                    caminhoImagem: 'assets/images/brasil.png',
                    idioma: 'Português',
                    isSelected: _idiomaSelecionado == 'Português',
                    onTap: _selecionarIdioma,
                  ),

                  const SizedBox(width: 32.0),
                  
                  PaisButtonWidget(
                    caminhoImagem: 'assets/images/estados-unidos.png',
                    idioma: 'Inglês',
                    isSelected: _idiomaSelecionado == 'Inglês',
                    onTap: _selecionarIdioma,
                  ),

                  const SizedBox(width: 32.0),

                  PaisButtonWidget(
                    caminhoImagem: 'assets/images/espanha.png',
                    idioma: 'Espanhol',
                    isSelected: _idiomaSelecionado == 'Espanhol',
                    onTap: _selecionarIdioma,
                  ),
                ],
              ),

              const SizedBox(height: 64.0),

              GestureDetector(
                onTap: () {
                  
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/rock_formation.jpg'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _traducoesBotao[_idiomaSelecionado] ?? _traducoesBotao['Português']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            ],

          ),
        ],
      ),
    );
  }
}

class PaisButtonWidget extends StatelessWidget {
  final String caminhoImagem;
  final String idioma;
  final bool isSelected;
  final Function(String) onTap;

  const PaisButtonWidget({
    super.key,
    required this.caminhoImagem,
    required this.idioma,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double saturationFactor = isSelected ? 1.0 : 0.75;
    final double borderWidth = isSelected ? 4.0 : 2.0;
    final Color borderColor = isSelected ? Color.fromARGB(90, 255, 255, 255) : const Color.fromARGB(175, 255, 255, 255);
    final double imageOpacity = isSelected ? 1.0 : 0.9;
    
    return InkWell(
      onTap: () {
        onTap(idioma);
      },
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(90, 255, 255, 255),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Opacity(
                opacity: imageOpacity,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(<double>[
                    saturationFactor, 0, 0, 0, 0,
                    0, saturationFactor, 0, 0, 0,
                    0, 0, saturationFactor, 0, 0,
                    0, 0, 0, 1, 0,
                  ]),
                  child: Image.asset(
                    caminhoImagem,
                    height: 80.0,
                    width: 80.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            idioma,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

}