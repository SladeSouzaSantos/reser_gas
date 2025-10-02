import 'package:flutter/material.dart';

import '../../../domain/data/components.dart';
import '../../../domain/models/component.dart';
import '../../../domain/models/component_fraction.dart';
import 'fabrica_tabela_componentes.dart';

typedef GetTranslation = String Function(String key);
typedef BuildConfirmButton = Widget Function(VoidCallback onPressed);

class BlocoEntradaComponentesConteudo extends StatelessWidget {
  final GetTranslation getTranslation;
  final String currentLanguage; 
  final List<ComponentFraction> selectedComponents;
  final Component selectedComponentToAdd;
  final ValueChanged<Component?> onComponentSelect;
  final TextEditingController fractionController;
  final VoidCallback onAddComponentFraction;
  final Function(ComponentFraction) onRemoveComponent;
  final double totalFraction;
  final List<String> availableComponentKeys;

  const BlocoEntradaComponentesConteudo({
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
    required this.availableComponentKeys,
  });
  
  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Text(
          getTranslation('aba_propriedades'),
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        Column( 
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [
              DropdownButtonFormField<Component>(
                decoration: InputDecoration(
                  labelText: getTranslation('dropdown_selecione'),
                  labelStyle: const TextStyle(color: Colors.amber),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                ),
                dropdownColor: const Color(0xFF2F333A),
                style: const TextStyle(color: Colors.white),
                initialValue: selectedComponentToAdd,
                items: availableComponentKeys.map((String key) {
                  final component = Components.getComponentByKey(key);
                  final componentDisplayName = getTranslation(key); 

                  return DropdownMenuItem<Component>(
                    value: component,
                    child: Text(componentDisplayName),
                  );
                }).toList(),
                onChanged: onComponentSelect,
              ),
              const SizedBox(height: 16),
              // Campo de Fração e Botão Adicionar
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: fractionController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: getTranslation('label_fracao'),
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
                      onPressed: onAddComponentFraction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(getTranslation('botao_adicionar')),
                    ),
                  ),
                ],
              ),
            ],
          ),

        const SizedBox(height: 32),
        
        selectedComponents.isEmpty
          ? Center(
                child: Text(
                  getTranslation('erro_tabela_vazia'), 
                  style: const TextStyle(color: Colors.white54),
                )
            )
          : criarTabelaComponentes(
              getTranslation: getTranslation,
              currentLanguage: currentLanguage,
              dados: selectedComponents,
              onRemove: onRemoveComponent,
              totalFraction: totalFraction,
            ),
      ],
    );
  }
}