import 'package:flutter/material.dart';
import '../../domain/data/components.dart'; 
import '../../domain/models/component.dart';
import '../../domain/models/component_fraction.dart';
import '../../domain/services/localization_service.dart';

class RadioGroup<T> extends StatelessWidget {
  const RadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.child,
  });

  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

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
      final remainingCapacity = 1.0 - currentTotal;
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
          _buildDensidadeInput(),
          _buildMassaMolecularInput(),
          _buildTabelaPropriedades(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDensidadeInput() {
    final String densityUnit = _selectedDensityType == 'Seca' ? _getTranslation('densidade_seco') : _getTranslation('densidade_umido'); 

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getTranslation('aba_densidade'),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
            RadioGroup<String>(
              groupValue: _selectedDensityType,              
              onChanged: _handleDensityChange, 
              child: Column(
                children: [
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_getTranslation('densidade_seco'), style: const TextStyle(color: Colors.white70)),
                    value: 'Seca',
                    groupValue: _selectedDensityType,
                    onChanged: _handleDensityChange,
                    activeColor: Colors.amber,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_getTranslation('densidade_umido'), style: const TextStyle(color: Colors.white70)),
                    value: 'Úmida',
                    groupValue: _selectedDensityType,
                    onChanged: _handleDensityChange,
                    activeColor: Colors.amber,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
            ),
            
          const SizedBox(height: 32),
          TextField(
            controller: _densityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: _getTranslation('label_densidade').replaceAll('{0}', densityUnit),
              labelStyle: const TextStyle(color: Colors.amber),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54),),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber),),
            ),
          ),
          _buildConfirmButton(_onConfirmDensidade),
        ],
      ),
    );
  }

  Widget _buildMassaMolecularInput() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
          _getTranslation('aba_massa'),
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
          controller: _massaMolecularController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: _getTranslation('label_massa_molecular'),
            labelStyle: const TextStyle(color: Colors.amber),
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54),),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber),),
          ),
          ),
          _buildConfirmButton(_onConfirmMassaMolecular),
        ],
      ),
    );
  }

  Widget _buildTabelaPropriedades() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
          _getTranslation('aba_propriedades'),
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          Column( 
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [
            DropdownButtonFormField<Component>(
              decoration: InputDecoration(
                labelText: _getTranslation('dropdown_selecione'),
                labelStyle: const TextStyle(color: Colors.amber),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
              ),
              dropdownColor: const Color(0xFF2F333A),
              style: const TextStyle(color: Colors.white),
              initialValue: _selectedComponentToAdd,
              items: Components.allKeys.map((String key) {
                final component = Components.getComponentByKey(key);
                final componentDisplayName = _localizationService.getTranslation(key, _currentLanguage);

                return DropdownMenuItem<Component>(
                  value: component,
                  child: Text(componentDisplayName),
                );
              }).toList(),
              onChanged: (Component? newValue) {
                if (newValue != null) {
                  setState(() {
          _selectedComponentToAdd = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
          controller: _fractionController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
          labelText: _getTranslation('label_fracao'),
          labelStyle: const TextStyle(color: Colors.amber), 
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
          onPressed: _addComponentFraction,
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(_getTranslation('botao_adicionar')),
                  ),
                ),
              ],
            ),
          ],
          ),

          const SizedBox(height: 32),
          
          _selectedComponents.isEmpty
          ? Center(
              child: Text('Nenhum componente adicionado.', style: const TextStyle(color: Colors.white54),)
            )
          : _buildComponentsTable(),

          _buildConfirmButton(_onConfirmPropriedades),
        ],
      ),
    );
  }

  Widget _buildComponentsTable() {
    final columns = [
      _getTranslation('cabecalho_componente'),
      _getTranslation('cabecalho_fracao'),
      _getTranslation('cabecalho_massa_molecular'),
      _getTranslation('cabecalho_pc'),
      _getTranslation('cabecalho_tc'),
      '',
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2228),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white38),
      ),
      child: Column(
        children: [

          Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: columns.map((title) => Expanded(
              flex: title == _getTranslation('cabecalho_componente') ? 3 : 2,
              child: Text(
                title,
                style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: title == '' ? TextAlign.center : TextAlign.left,
              ),
            )).toList(),
          ),
          ),
          const Divider(color: Colors.white38, height: 1),
          
          ..._selectedComponents.map((item) => _TableItemRow(
          item: item,
          onRemove: _removeComponent,
          
          translateComponent: (key) => _localizationService.getTranslation(key, _currentLanguage), 
          )),

          const Divider(color: Colors.white38, height: 1),
          
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  
                  _getTranslation('total_somatoria'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  _totalFraction.toStringAsFixed(4),
                  style: TextStyle(
          color: _totalFraction > 1.00001 ? Colors.red : Colors.greenAccent,
          fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Expanded(flex: 2, child: SizedBox()),
              const Expanded(flex: 2, child: SizedBox()),
              const Expanded(flex: 2, child: SizedBox()),
              const Expanded(flex: 2, child: SizedBox()),
            ],
          ),
          )
        ],
      ),
    );
  }
}


class _TableItemRow extends StatelessWidget {
  final ComponentFraction item;
  final Function(ComponentFraction) onRemove;
  
  final String Function(String key) translateComponent;

  const _TableItemRow({
    required this.item, 
    required this.onRemove,
    required this.translateComponent,
  });

  @override
  Widget build(BuildContext context) {
    final componentDisplayName = translateComponent(item.component.name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Row(
        children: [
          Expanded(
          flex: 3,
          child: Text(
            componentDisplayName.length > 15 
              ? '${componentDisplayName.substring(0, 12)}...'
              : componentDisplayName,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          ),

          Expanded(
          flex: 2,
          child: Text(
            item.fraction.toStringAsFixed(4),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          ),
          
          Expanded(
          flex: 2,
          child: Text(
            item.component.molecularWeight.toStringAsFixed(3),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          ),
          
          Expanded(
          flex: 2,
          child: Text(
            item.component.pseudocriticalPressure.toStringAsFixed(2),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          ),
          
          Expanded(
          flex: 2,
          child: Text(
            item.component.pseudocriticalTemperature.toStringAsFixed(2),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          ),
          
          Expanded(
          flex: 2,
          child: IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red, size: 18),
            onPressed: () => onRemove(item),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          ),
        ],
      ),
    );
  }
}