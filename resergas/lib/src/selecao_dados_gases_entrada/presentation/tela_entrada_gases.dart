import 'package:flutter/material.dart';

import 'package:resergas/src/selecao_dados_gases_entrada/usercases/densidade_componentes_controller.dart'; 
import 'package:resergas/src/selecao_dados_gases_entrada/usercases/entrada_gases_controller.dart'; 
import 'package:resergas/src/selecao_dados_gases_entrada/usercases/propriedades_gases_controller.dart'; // Controller de Propriedades

import '../../domain/data/components.dart';
import '../../domain/services/localization_service.dart';

import '../widgets/entrada_densidade_widget.dart';
import '../widgets/entrada_massa_molecular_widget.dart';
import '../widgets/entrada_propriedades_widget.dart';


class TelaEntradaGases extends StatefulWidget {
  final String idiomaSelecionado;
  const TelaEntradaGases({
    super.key,
    required this.idiomaSelecionado,
  });

  @override
  State<TelaEntradaGases> createState() => _TelaEntradaGasesState();
}

class _TelaEntradaGasesState extends State<TelaEntradaGases> {
  
  final LocalizationService _localizationService = LocalizationService();
  
  late final EntradaGasesController _massaMolecularController;
  late final DensidadeComponentesController _densidadeComponentesController;
  late final PropriedadesGasesController _propriedadesGasesController;
  
  late String _currentLanguage;
  
  @override
  void initState() {
    super.initState();
    
    _currentLanguage = widget.idiomaSelecionado;
    
    // Inicialização de todos os Controllers
    _massaMolecularController = EntradaGasesController(idiomaInicial: _currentLanguage);
    _densidadeComponentesController = DensidadeComponentesController(idiomaInicial: _currentLanguage);
    _propriedadesGasesController = PropriedadesGasesController(idiomaInicial: _currentLanguage); 
    
    // Adicionar listeners para acionar rebuild da UI (setState) quando o Controller muda
    _massaMolecularController.addListener(_onControllerChange);
    _densidadeComponentesController.addListener(_onControllerChange);
    _propriedadesGasesController.addListener(_onControllerChange); // Listener para Propriedades
  }

  // Função chamada sempre que um Controller notifica uma mudança (changeNotifier)
  void _onControllerChange() {
    setState(() {});
  }
  
  // --- MÉTODOS DE TRADUÇÃO ---
  String _getTranslation(String key) {
    return _localizationService.getTranslation(key, _currentLanguage);
  }
  
  // --- MÉTODOS DE CONSTRUÇÃO DE UI ---
  Widget _buildConfirmButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber, 
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        _getTranslation('botao_confirmar'),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void dispose() {
    
    _massaMolecularController.removeListener(_onControllerChange);
    _densidadeComponentesController.removeListener(_onControllerChange);
    _propriedadesGasesController.removeListener(_onControllerChange); 
    
    _massaMolecularController.dispose();
    _densidadeComponentesController.dispose();
    _propriedadesGasesController.dispose(); 
    
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E), 
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            _getTranslation('titulo'),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: _getTranslation('aba_densidade')),
              Tab(text: _getTranslation('aba_massa')),
              Tab(text: _getTranslation('aba_propriedades')),
            ],
            labelColor: Colors.amber, 
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.amber,
          ),
        ),
        body: TabBarView(
          children: [
            EntradaDensidadeWidget(
              getTranslation: _getTranslation,
              selectedDensityType: _densidadeComponentesController.selectedDensityType,
              onDensityChange: _densidadeComponentesController.handleDensityChange,
              densityController: _densidadeComponentesController.densityController,              
              onConfirm: ({required BuildContext context, required String contaminanteOption}) => 
                  _densidadeComponentesController.validateAndConfirmDensidade(
                      context: context, 
                      contaminanteOption: contaminanteOption
                  ),              
              currentLanguage: _currentLanguage,
              selectedComponents: _densidadeComponentesController.selectedComponents,
              selectedComponentToAdd: _densidadeComponentesController.selectedComponentToAdd,
              onComponentSelect: _densidadeComponentesController.handleComponentSelect,
              onAddComponentFraction: () => _densidadeComponentesController.addComponentFraction(context),
              onRemoveComponent: (cf) => _densidadeComponentesController.removeComponent(context, cf),
              totalFraction: _densidadeComponentesController.totalFraction,
              fractionController: _densidadeComponentesController.fractionController,
              availableComponentKeys: Components.nonHydrocarbonKeys,
              buildConfirmButton: _buildConfirmButton, 
            ),
            
            
            EntradaMassaMolecularWidget(
              getTranslation: _getTranslation,
              massaMolecularController: _massaMolecularController.massaMolecularController,
              onConfirm: (context) => _massaMolecularController.onConfirmMassaMolecular(context),
              contaminanteOption: _massaMolecularController.contaminanteOption,
              onContaminanteChange: _massaMolecularController.handleContaminanteChange,
              currentLanguage: _massaMolecularController.currentLanguage,
              selectedComponents: _massaMolecularController.selectedComponents,
              selectedComponentToAdd: _massaMolecularController.selectedComponentToAdd,
              onComponentSelect: _massaMolecularController.handleComponentSelect,
              fractionController: _massaMolecularController.fractionController,
              onAddComponentFraction: () => _massaMolecularController.addComponentFraction(context),
              onRemoveComponent: (cf) => _massaMolecularController.removeComponent(context, cf),
              totalFraction: _massaMolecularController.totalFraction,
              buildConfirmButton: _buildConfirmButton,
            ),
            
            EntradaPropriedadesWidget(
              getTranslation: _getTranslation,
              currentLanguage: _currentLanguage,
              selectedComponents: _propriedadesGasesController.selectedComponents, 
              selectedComponentToAdd: _propriedadesGasesController.selectedComponentToAdd, 
              onComponentSelect: _propriedadesGasesController.handleComponentSelect, 
              fractionController: _propriedadesGasesController.fractionController, 
              onAddComponentFraction: () => _propriedadesGasesController.addComponentFraction(context),
              onRemoveComponent: (cf) => _propriedadesGasesController.removeComponent(context, cf), 
              totalFraction: _propriedadesGasesController.totalFraction,
              onConfirm: () => _propriedadesGasesController.onConfirmPropriedades(context),
              buildConfirmButton: _buildConfirmButton,
            ),
          ],
        ),
      ),
    );
  }
}