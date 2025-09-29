import 'package:flutter/material.dart';
import 'package:resergas/src/selecao_idioma/widgets/pais_button_widget.dart';
import '../../domain/services/localization_service.dart';
import '../../selecao_dados_gases_entrada/presentation/tela_entrada_gases.dart';

class TelaSelecaoIdioma extends StatefulWidget {
  const TelaSelecaoIdioma({super.key});

  @override
  State<TelaSelecaoIdioma> createState() => _TelaSelecaoIdiomaState();
}

class _TelaSelecaoIdiomaState extends State<TelaSelecaoIdioma> {
  
  final LocalizationService _localizationService = LocalizationService();
  
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
  
  void _confirmarSelecao(BuildContext context) {
    if (_idiomaSelecionado != null) {
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaEntradaGases(
            idiomaSelecionado: _idiomaSelecionado!, 
          ),
        ),
      );

    } else {
      final String errorMessage = _localizationService.getTranslation('erro_selecao_idioma', 'Português');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    
    final String currentLang = _idiomaSelecionado ?? 'Português';    
    final String tituloCentral = _localizationService.getTranslation('selecao_idioma_titulo', currentLang);    
    final String textoBotao = _localizationService.getTranslation('botao_confirmar_selecao', currentLang);

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
            spacing: MediaQuery.of(context).size.height * 0.1,
            children: [              
              Text(
                tituloCentral,
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
                    idioma: 'Inglês', // Deve corresponder à chave no LocalizationService
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
                   _confirmarSelecao(context);
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
                        color: Color.fromARGB(255, 255, 255, 255),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    textoBotao,
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