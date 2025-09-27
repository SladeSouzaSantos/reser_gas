import 'package:flutter/material.dart';
import 'package:resergas/src/selecao_idioma/widgets/pais_button_widget.dart';

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
            spacing: 96.0,
            children: [
              Text(
                _traducoes[_idiomaSelecionado] ?? _traducoes['Português']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 32.0,
                children: [
                  PaisButtonWidget(
                    caminhoImagem: 'assets/images/brasil.png',
                    idioma: 'Português',
                    isSelected: _idiomaSelecionado == 'Português',
                    onTap: _selecionarIdioma,
                  ),
                  
                  PaisButtonWidget(
                    caminhoImagem: 'assets/images/estados-unidos.png',
                    idioma: 'Inglês',
                    isSelected: _idiomaSelecionado == 'Inglês',
                    onTap: _selecionarIdioma,
                  ),

                  PaisButtonWidget(
                    caminhoImagem: 'assets/images/espanha.png',
                    idioma: 'Espanhol',
                    isSelected: _idiomaSelecionado == 'Espanhol',
                    onTap: _selecionarIdioma,
                  ),
                ],
              ),

              InkWell(
                onTap: () {                  
                },
                borderRadius: BorderRadius.circular(25.0),
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