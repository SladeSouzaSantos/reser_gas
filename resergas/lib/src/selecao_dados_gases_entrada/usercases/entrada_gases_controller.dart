import 'package:flutter/material.dart';
import '../../domain/data/components.dart'; 
import '../../domain/models/component.dart';
import '../../domain/models/component_fraction.dart';
import '../../domain/services/localization_service.dart';

class EntradaGasesController extends ChangeNotifier {
  
  final LocalizationService _localizationService = LocalizationService(); // Usada como utilitário
  final String _currentLanguage; // O Controller armazena a string do idioma

  // CONSTRUTOR ATUALIZADO
  EntradaGasesController({required String idiomaInicial}) 
    : _currentLanguage = idiomaInicial; // Inicializa o idioma no construtor

  // --- 1. ESTADO DE ENTRADA ---
  
  final TextEditingController densityController = TextEditingController();
  final TextEditingController massaMolecularController = TextEditingController();
  final TextEditingController fractionController = TextEditingController();
  
  String _selectedDensityType = 'Seca';
  String get selectedDensityType => _selectedDensityType;

  final List<ComponentFraction> _selectedComponents = [];
  List<ComponentFraction> get selectedComponents => _selectedComponents;
  
  Component _selectedComponentToAdd = Components.getComponentByKey("Methane");
  Component get selectedComponentToAdd => _selectedComponentToAdd;
  
  double _totalFraction = 0.0;
  double get totalFraction => _totalFraction;

  // NOVO GETTER PÚBLICO PARA O IDIOMA (Usado pela View)
  String get currentLanguage => _currentLanguage; 

  // --- 2. LÓGICA DE ESTADO ---

  // Método de tradução, usa o idioma interno
  String getTranslation(String key) {
    // Passa a string do idioma explicitamente para o serviço de tradução
    return _localizationService.getTranslation(key, _currentLanguage);
  }

  void _calculateTotalFraction() {
    _totalFraction = _selectedComponents.fold(0.0, (sum, item) => sum + item.fraction);
  }

  void handleDensityChange(String? newValue) {
    if (newValue != null) {
      _selectedDensityType = newValue;
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
    
    if (newTotal > 1.00001) { 
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

  // --- 3. Lógica de Confirmação ---
  
  void onConfirmDensidade() {
    debugPrint('Confirmação de Densidade! Tipo: $_selectedDensityType, Valor: ${densityController.text}');
  }
  
  void onConfirmMassaMolecular() {
    debugPrint('Confirmação de Massa Molecular! Valor: ${massaMolecularController.text}');
  }
  
  void onConfirmPropriedades(BuildContext context) {
    if (_totalFraction < 0.99999) {
      _showSnackBar(context, getTranslation('erro_soma_menor_um'), Colors.red);
      return;
    }
    if (_totalFraction > 1.00001) {
       _showSnackBar(context, getTranslation('erro_soma_maior_um'), Colors.red);
      return;
    }
    
    debugPrint('Confirmação de Propriedades! Total: $_totalFraction, Componentes: ${_selectedComponents.length}');
  }

  // --- 4. UI Utility (SnackBar) ---
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
    densityController.dispose();
    massaMolecularController.dispose();
    fractionController.dispose();
    super.dispose();
  }
}