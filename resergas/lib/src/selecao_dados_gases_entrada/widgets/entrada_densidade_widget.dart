import 'package:flutter/material.dart';

import '../../domain/models/component.dart';
import '../../domain/models/component_fraction.dart';
import 'tabela/bloco_entrada_componentes.dart'; 

typedef GetTranslation = String Function(String key);
typedef BuildConfirmButton = Widget Function(VoidCallback onPressed);

typedef OnComponentSelect = ValueChanged<Component?>;
typedef OnRemoveComponent = Function(ComponentFraction);

typedef OnConfirmDensidade = void Function({
  required BuildContext context, 
  required String contaminanteOption,
});

class EntradaDensidadeWidget extends StatefulWidget {
  
  final GetTranslation getTranslation;
  final String selectedDensityType;
  final ValueChanged<String?> onDensityChange;
  final TextEditingController densityController;
  final OnConfirmDensidade onConfirm;
  final BuildConfirmButton buildConfirmButton;
  
  final String currentLanguage; 
  final List<ComponentFraction> selectedComponents;
  final Component selectedComponentToAdd;
  final OnComponentSelect onComponentSelect;
  final TextEditingController fractionController;
  final VoidCallback onAddComponentFraction;
  final OnRemoveComponent onRemoveComponent;
  final double totalFraction;
  final List<String> availableComponentKeys; 

  const EntradaDensidadeWidget({
    super.key,
    required this.getTranslation,
    required this.selectedDensityType,
    required this.onDensityChange,
    required this.densityController,
    required this.onConfirm, 
    required this.buildConfirmButton,
    required this.currentLanguage,
    required this.selectedComponents,
    required this.selectedComponentToAdd,
    required this.onComponentSelect,
    required this.fractionController,
    required this.onAddComponentFraction,
    required this.onRemoveComponent,
    required this.totalFraction,
    required this.availableComponentKeys,
  });

  @override
  State<EntradaDensidadeWidget> createState() => _EntradaDensidadeWidgetState();
}

class _EntradaDensidadeWidgetState extends State<EntradaDensidadeWidget> {
  
  String contaminanteOption = 'sem';
  
  void _triggerValidation() {
    widget.onConfirm(
      context: context,
      contaminanteOption: contaminanteOption,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String densityUnit = widget.selectedDensityType == 'Seca' 
      ? widget.getTranslation('densidade_seco') 
      : widget.getTranslation('densidade_umido'); 

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            widget.getTranslation('aba_densidade'),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          Column(
            children: [
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: Text(widget.getTranslation('densidade_seco'), style: const TextStyle(color: Colors.white70)),
                value: 'Seco',
                groupValue: widget.selectedDensityType,
                onChanged: widget.onDensityChange,
                activeColor: Colors.amber,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: Text(widget.getTranslation('densidade_umido'), style: const TextStyle(color: Colors.white70)),
                value: 'Úmido',
                groupValue: widget.selectedDensityType,
                onChanged: widget.onDensityChange,
                activeColor: Colors.amber,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),

          const SizedBox(height: 32),
          
          TextField(
            controller: widget.densityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: widget.getTranslation('label_densidade').replaceAll('{0}', densityUnit),
              labelStyle: const TextStyle(color: Colors.amber),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54),),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber),),
            ),
          ),
          
          const SizedBox(height: 32),
          
          Text(
            widget.getTranslation('label_contaminantes'),
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          RadioListTile<String>(
            contentPadding: EdgeInsets.zero,
            title: Text(widget.getTranslation('sem_contaminantes'), style: const TextStyle(color: Colors.white70)),
            value: 'sem',
            groupValue: contaminanteOption,
            onChanged: (value) {
              setState(() {
                contaminanteOption = value!;
              });
            },
            activeColor: Colors.amber,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          RadioListTile<String>(
            contentPadding: EdgeInsets.zero,
            title: Text(widget.getTranslation('com_contaminantes'), style: const TextStyle(color: Colors.white70)),
            value: 'com',
            groupValue: contaminanteOption,
            onChanged: (value) {
              setState(() {
                contaminanteOption = value!;
              });
            },
            activeColor: Colors.amber,
            controlAffinity: ListTileControlAffinity.leading,
          ),

          const SizedBox(height: 16),
          
          if (contaminanteOption == 'com')
            BlocoEntradaComponentesConteudo(
              getTranslation: widget.getTranslation,
              currentLanguage: widget.currentLanguage,
              selectedComponents: widget.selectedComponents,
              selectedComponentToAdd: widget.selectedComponentToAdd,
              onComponentSelect: widget.onComponentSelect,
              fractionController: widget.fractionController,
              onAddComponentFraction: widget.onAddComponentFraction,
              onRemoveComponent: widget.onRemoveComponent,
              totalFraction: widget.totalFraction,
              availableComponentKeys: widget.availableComponentKeys, 
            ),

          const SizedBox(height: 32),
          
          Center(
            child: widget.buildConfirmButton(_triggerValidation),
          ),
          
        ],
      ),
    );
  }
}