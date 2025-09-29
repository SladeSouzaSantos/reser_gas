import 'package:flutter/material.dart';
import '../../domain/data/components.dart'; 
import '../../domain/models/component.dart';
import '../../domain/models/component_fraction.dart';
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
  
  late String _currentLanguage;
  
  String _selectedDensityType = 'Seca';
  
  final List<ComponentFraction> _selectedComponents = [];
  
  Component _selectedComponentToAdd = Components.getComponentByKey("Methane");
  
  final TextEditingController _densityController = TextEditingController();
  final TextEditingController _massaMolecularController = TextEditingController();
  final TextEditingController _fractionController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    _currentLanguage = widget.idiomaSelecionado;
    
    final firstKey = Components.allKeys.isNotEmpty ? Components.allKeys.first : 'Methane';
    _selectedComponentToAdd = Components.getComponentByKey(firstKey);
  }

  @override
  void dispose() {
    _densityController.dispose();
    _massaMolecularController.dispose();
    _fractionController.dispose();
    super.dispose();
  }
  
  String _getTranslation(String key) {
    return _localizationService.getTranslation(key, _currentLanguage);
  }
  
  void _handleDensityChange(String? value) {
    if (value != null) {
      setState(() {
        _selectedDensityType = value;
      });
    }
  }
  
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(milliseconds: 2500),
      ),
    );
  }
  
  Widget _buildConfirmButton(VoidCallback onPressed) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(_getTranslation('botao_confirmar'), style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
  
  double get _totalFraction => _selectedComponents.fold(0.0, (sum, item) => sum + item.fraction);
  
  void _onConfirmSimpleValue(TextEditingController controller) {
    final value = double.tryParse(controller.text.replaceAll(',', '.'));
    if (value == null || value <= 0) {
      _showSnackBar(_getTranslation('erro_zero'), Colors.red);
      return;
    }
    _showSnackBar(_getTranslation('sucesso_confirmar'), Colors.green);

  }

  void _onConfirmDensidade() {
    _onConfirmSimpleValue(_densityController);
  }

  void _onConfirmMassaMolecular() {
    _onConfirmSimpleValue(_massaMolecularController);
  }

  void _onConfirmPropriedades() {
    final total = _totalFraction;
    
    if (total <= 0) {
      _showSnackBar(_getTranslation('erro_tabela_zero'), Colors.red);
      return;
    }
    
    if (total > 1.0 + 1e-6) { 
      _showSnackBar(_getTranslation('erro_soma_maior_um'), Colors.red);
      return;
    }

    _showSnackBar(_getTranslation('sucesso_confirmar'), Colors.green);
  
  }
  
  void _addComponentFraction() {
    final fractionText = _fractionController.text.replaceAll(',', '.');
    final newFraction = double.tryParse(fractionText);

    if (newFraction == null || newFraction <= 0) {
      _showSnackBar(_getTranslation('erro_fracao_invalida'), Colors.red);
      return;
    }
    
    final existingIndex = _selectedComponents.indexWhere(
      (item) => item.component.name == _selectedComponentToAdd.name,
    );

    final currentTotal = _totalFraction;
    
    double fractionAfterAddition;
    if (existingIndex != -1) {
      fractionAfterAddition = currentTotal - _selectedComponents[existingIndex].fraction + newFraction;
    } else {

      fractionAfterAddition = currentTotal + newFraction;
    }
    
    if (fractionAfterAddition > 1.0 + 1e-6) { 
      final remainingCapacity = 1.0 - (existingIndex != -1 ? (currentTotal - _selectedComponents[existingIndex].fraction) : currentTotal);
      _showSnackBar(
        _getTranslation('erro_max_fracao_atingido')
        .replaceAll('{0}', remainingCapacity.clamp(0.0, 1.0).toStringAsFixed(3)), 
        Colors.red,
      );
      return;
    }

    setState(() {
      if (existingIndex != -1) {
        final currentItem = _selectedComponents[existingIndex];
        _selectedComponents[existingIndex] = currentItem.copyWith(fraction: newFraction);
      } else {
      
        _selectedComponents.add(ComponentFraction(
          component: _selectedComponentToAdd, 
          fraction: newFraction,
        ));
      }
      
      _fractionController.clear();
      _showSnackBar(_getTranslation('componente_adicionado'), Colors.green);
    });
  }

  void _removeComponent(ComponentFraction item) {
    setState(() {
      _selectedComponents.remove(item);
    });
    _showSnackBar(_getTranslation('componente_removido'), Colors.orange);
  }
  
  void _handleComponentSelect(Component? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedComponentToAdd = newValue;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color(0xFF2F333A),
          title: Text(
            _getTranslation('titulo'),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: _getTranslation('aba_densidade')),
              Tab(text: _getTranslation('aba_massa')),
              Tab(text: _getTranslation('aba_propriedades')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Aba 1: Densidade
            EntradaDensidadeWidget(
              getTranslation: _getTranslation,
              selectedDensityType: _selectedDensityType,
              onDensityChange: _handleDensityChange,
              densityController: _densityController,
              onConfirm: _onConfirmDensidade,
              buildConfirmButton: _buildConfirmButton,
            ),
            
            // Aba 2: Massa Molecular
            EntradaMassaMolecularWidget(
              getTranslation: _getTranslation,
              massaMolecularController: _massaMolecularController,
              onConfirm: _onConfirmMassaMolecular,
              buildConfirmButton: _buildConfirmButton,
            ),
            
            // Aba 3: Propriedades
            EntradaPropriedadesWidget(
              getTranslation: _getTranslation,
              currentLanguage: _currentLanguage,
              selectedComponents: _selectedComponents,
              selectedComponentToAdd: _selectedComponentToAdd,
              onComponentSelect: _handleComponentSelect,
              fractionController: _fractionController,
              onAddComponentFraction: _addComponentFraction,
              onRemoveComponent: _removeComponent,
              totalFraction: _totalFraction,
              onConfirm: _onConfirmPropriedades,
              buildConfirmButton: _buildConfirmButton,
            ),
          ],
        ),
      ),
    );
  }
}