import 'package:flutter/material.dart';

import '../../domain/data/components.dart'; 
import '../../domain/models/component.dart';
import '../../domain/models/component_fraction.dart';
import '../widgets/tabela/bloco_entrada_componentes.dart';

typedef GetTranslation = String Function(String key);
typedef BuildConfirmButton = Widget Function(VoidCallback onPressed);
typedef OnConfirmWithContext = void Function(BuildContext context);

class EntradaMassaMolecularWidget extends StatelessWidget {
  final GetTranslation getTranslation;
  final TextEditingController massaMolecularController;
  final OnConfirmWithContext onConfirm;
  final BuildConfirmButton buildConfirmButton;
  
  final String contaminanteOption;
  final ValueChanged<String?> onContaminanteChange;
  
  final String currentLanguage; 
  final List<ComponentFraction> selectedComponents;
  final Component selectedComponentToAdd;
  final ValueChanged<Component?> onComponentSelect;
  final TextEditingController fractionController;
  final VoidCallback onAddComponentFraction;
  final Function(ComponentFraction) onRemoveComponent;
  final double totalFraction;

  const EntradaMassaMolecularWidget({
    super.key,
    required this.getTranslation,
    required this.massaMolecularController,
    required this.onConfirm,
    required this.buildConfirmButton,
    
    required this.contaminanteOption,
    required this.onContaminanteChange,
    
    required this.currentLanguage, 
    required this.selectedComponents,
    required this.selectedComponentToAdd,
    required this.onComponentSelect,
    required this.fractionController,
    required this.onAddComponentFraction,
    required this.onRemoveComponent,
    required this.totalFraction,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslation('aba_massa'),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: massaMolecularController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: getTranslation('label_massa_molecular'),
              labelStyle: const TextStyle(color: Colors.amber),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54),),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber),),
            ),
          ),
          
          const SizedBox(height: 32),
          
          Text(
            getTranslation('label_contaminantes'),
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          
          RadioListTile<String>(
            contentPadding: EdgeInsets.zero,
            title: Text(getTranslation('sem_contaminantes'), style: const TextStyle(color: Colors.white70)),
            value: 'sem',
            groupValue: contaminanteOption,
            onChanged: onContaminanteChange,
            activeColor: Colors.amber,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          
          RadioListTile<String>(
            contentPadding: EdgeInsets.zero,
            title: Text(getTranslation('com_contaminantes'), style: const TextStyle(color: Colors.white70)),
            value: 'com',
            groupValue: contaminanteOption,
            onChanged: onContaminanteChange,
            activeColor: Colors.amber,
            controlAffinity: ListTileControlAffinity.leading,
          ),

          const SizedBox(height: 16),
          
          if (contaminanteOption == 'com')
            BlocoEntradaComponentesConteudo(
              getTranslation: getTranslation,
              currentLanguage: currentLanguage,
              selectedComponents: selectedComponents,
              selectedComponentToAdd: selectedComponentToAdd,
              onComponentSelect: onComponentSelect, 
              fractionController: fractionController, 
              onAddComponentFraction: onAddComponentFraction,
              onRemoveComponent: onRemoveComponent,
              totalFraction: totalFraction,
              availableComponentKeys: Components.nonHydrocarbonKeys,
            ),
          
          const SizedBox(height: 32),

          Center(
            child: buildConfirmButton(() => onConfirm(context)),
          ),
          
        ],
      ),
    );
  }
}