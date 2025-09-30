import 'package:flutter/material.dart';

import '../../domain/data/components.dart';
import '../../domain/models/component.dart';
import '../../domain/models/component_fraction.dart';
import 'tabela/bloco_entrada_componentes.dart';

typedef GetTranslation = String Function(String key);
typedef BuildConfirmButton = Widget Function(VoidCallback onPressed);



class EntradaPropriedadesWidget extends StatelessWidget {

  final GetTranslation getTranslation;
  final String currentLanguage; 
  final List<ComponentFraction> selectedComponents;
  final Component selectedComponentToAdd;
  final ValueChanged<Component?> onComponentSelect;
  final TextEditingController fractionController;
  final VoidCallback onAddComponentFraction;
  final Function(ComponentFraction) onRemoveComponent;
  final double totalFraction;
  
  final VoidCallback onConfirm;
  final BuildConfirmButton buildConfirmButton;

  const EntradaPropriedadesWidget({
    super.key,
    required this.getTranslation,
    required this.currentLanguage, 
    required this.selectedComponents,
    required this.selectedComponentToAdd,
    required this.onComponentSelect,
    required this.fractionController,
    required this.onAddComponentFraction,
    required this.onRemoveComponent,
    required this.totalFraction,
    required this.onConfirm,
    required this.buildConfirmButton,
  });
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            availableComponentKeys: Components.allKeys, 
          ),

          const SizedBox(height: 32),

          Center(
            child: buildConfirmButton(onConfirm),
          ),
        ],
      ),
    );
  }
}