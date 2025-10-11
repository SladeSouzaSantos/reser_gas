import 'package:flutter/material.dart';
import 'package:resergas/src/selecao_dados_gases_entrada/usercases/calculos/calcular_densidade.dart';
import '../../apresentacao_dados_reservatorio_gas/presentation/tela_dados_reservatorio.dart';
import '../../domain/data/components.dart'; 
import '../../domain/models/component.dart';
import '../../domain/models/component_fraction.dart';
import '../../domain/services/localization_service.dart';
import '../../domain/models/gas_reservatorio.dart';
import 'calculos/calcular_propriedades_composicao_gas.dart';

class MassaMolecularController extends ChangeNotifier {

  final LocalizationService _localizationService = LocalizationService(); 
  final String _currentLanguage;
  
  MassaMolecularController({required String idiomaInicial}) 
    : _currentLanguage = idiomaInicial;
    
  final TextEditingController massaMolecularController = TextEditingController();
  
  String _contaminanteOption = 'sem';
  String get contaminanteOption => _contaminanteOption;
  
  final TextEditingController fractionController = TextEditingController();


  final List<ComponentFraction> _selectedComponents = [];
  List<ComponentFraction> get selectedComponents => _selectedComponents;

  Component _selectedComponentToAdd = Components.getComponentByKey("Nitrogen"); 
  Component get selectedComponentToAdd => _selectedComponentToAdd;

  double _totalFraction = 0.0;
  double get totalFraction => _totalFraction;


  String get currentLanguage => _currentLanguage;
  
  String getTranslation(String key) {

    return _localizationService.getTranslation(key, _currentLanguage);
  }

  void _calculateTotalFraction() {
    _totalFraction = _selectedComponents.fold(0.0, (sum, item) => sum + item.fraction);
  }
  
  void handleContaminanteChange(String? newValue) {
    if (newValue != null) {
      _contaminanteOption = newValue;
      
      if (newValue == 'sem') {
        _clearTabela(newValue); 
      }
      notifyListeners();
    }
  }

  void handleComponentSelect(Component? newComponent) {
    if (newComponent != null) {
      _selectedComponentToAdd = newComponent;
      notifyListeners(); 
    }
  }
  
  void addComponentFraction(BuildContext context) {
    final String fractionText = fractionController.text;
    final double? fractionValue = double.tryParse(fractionText.replaceAll(',', '.'));

    if (fractionValue == null || fractionValue <= 0) {
      _showSnackBar(context, getTranslation('erro_fracao_invalida'), Colors.red);
      return;
    }

    final Component newComponent = _selectedComponentToAdd;
    final double currentTotal = _totalFraction;

    final bool isAlreadyAdded = _selectedComponents.any((c) => c.component.name == newComponent.name);

    double newTotal = currentTotal + fractionValue;

    if (isAlreadyAdded) {
      final existingFraction = _selectedComponents.firstWhere((c) => c.component.name == newComponent.name).fraction;
      newTotal = currentTotal - existingFraction + fractionValue;
    }

    if (newTotal > 1.0) { 
      final double remaining = 1.0 - (currentTotal - (isAlreadyAdded ? _selectedComponents.firstWhere((c) => c.component.name == newComponent.name).fraction : 0.0));
      final String msg = getTranslation('erro_max_fracao_atingido').replaceAll('{0}', remaining.toStringAsFixed(4));
      _showSnackBar(context, msg, Colors.red);
      return;
    }

    if (isAlreadyAdded) {
      final index = _selectedComponents.indexWhere((c) => c.component.name == newComponent.name);
      _selectedComponents[index] = ComponentFraction(
        component: newComponent, 
        fraction: fractionValue
      );
    } else {
      _selectedComponents.add(ComponentFraction(
        component: newComponent, 
        fraction: fractionValue
      ));
    }

    _calculateTotalFraction();
    _showSnackBar(context, getTranslation('componente_adicionado'), Colors.green);
    fractionController.clear();
    notifyListeners();
  }

  void removeComponent(BuildContext context, ComponentFraction componentFraction) {
    _selectedComponents.removeWhere((c) => c.component.name == componentFraction.component.name);
    _calculateTotalFraction();
    _showSnackBar(context, getTranslation('componente_removido'), Colors.orange);
    notifyListeners();
  }
  
  void onConfirmMassaMolecular(BuildContext context) {

    final String massaText = massaMolecularController.text.trim();
    final double? massa = double.tryParse(massaText.replaceAll(',', '.'));
    
    final bool hasComponentInput = _selectedComponents.isNotEmpty;

    if (massa == null || massa <= 0) {
      _showSnackBar(context, getTranslation('erro_massa_invalida'), Colors.red);
      return;
    }
    
    if (_contaminanteOption == 'com') {
      if (!hasComponentInput) {
        
        _showSnackBar(context, getTranslation('erro_sem_componentes'), Colors.red); 
        return;
      }
      
      if (_totalFraction <= (0.0)) {
        _showSnackBar(context, getTranslation('erro_soma_menor_igual_zero'), Colors.red);
        return;
      }
      if (_totalFraction > (1.0)) {
        _showSnackBar(context, getTranslation('erro_soma_maior_um'), Colors.red);
        return;
      }
    }
    
    _clearTabela(contaminanteOption);
    
    final (dg, tipo) = CalcularDensidade().calcular(massaMolecular: massa);

    final gasComponentResult = CalcularPropriedadesComposicaoGas.calcular(components: _selectedComponents);
        
    final inputData = GasReservatorio(
      gasComponents: gasComponentResult,
      molecularWeight: massa,
      gasDensity: dg,
      gasClassification: tipo,
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => TelaDadosReservatorio(
          idiomaSelecionado: _currentLanguage,
          gasInputData: inputData,
        ),
      ),
    );

  }

  void _clearTabela(String contaminanteOption){
    if (contaminanteOption == "sem") {
      _selectedComponents.clear();
      _totalFraction = 0;
    }    
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    if (ScaffoldMessenger.of(context).mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    
    massaMolecularController.dispose();
    fractionController.dispose();
    super.dispose();
  }
}