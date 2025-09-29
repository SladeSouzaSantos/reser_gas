import 'package:flutter/material.dart';
import '../../domain/data/components.dart'; 
import '../../domain/models/component.dart';
import '../../domain/models/component_fraction.dart';
import '../../domain/services/localization_service.dart';

typedef GetTranslation = String Function(String key);
typedef BuildConfirmButton = Widget Function(VoidCallback onPressed);

// Widget de linha da tabela
class TableItemRow extends StatelessWidget {
  final ComponentFraction item;
  final Function(ComponentFraction) onRemove;
  final String Function(String key) translateComponent;

  const TableItemRow({
    super.key,
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

class EntradaPropriedadesWidget extends StatelessWidget {
  final GetTranslation getTranslation;
  final String currentLanguage; // Parâmetro para o idioma
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
  
  // Método auxiliar para construir a tabela de componentes
  Widget _buildComponentsTable() {
    // Instância necessária para a callback de tradução do TableItemRow
    final LocalizationService localizationService = LocalizationService(); 

    final columns = [
      getTranslation('cabecalho_componente'),
      getTranslation('cabecalho_fracao'),
      getTranslation('cabecalho_massa_molecular'),
      getTranslation('cabecalho_pc'),
      getTranslation('cabecalho_tc'),
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
                flex: title == getTranslation('cabecalho_componente') ? 3 : 2,
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                  textAlign: title == '' ? TextAlign.center : TextAlign.left,
                ),
              )).toList(),
            ),
          ),
          const Divider(color: Colors.white38, height: 1),
          
          ...selectedComponents.map((item) => TableItemRow(
            item: item,
            onRemove: onRemoveComponent,
            // Passamos a função de tradução com o idioma correto
            translateComponent: (key) => localizationService.getTranslation(key, currentLanguage), 
          )),

          const Divider(color: Colors.white38, height: 1),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    getTranslation('total_somatoria'),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    totalFraction.toStringAsFixed(4),
                    style: TextStyle(
                      color: totalFraction > 1.00001 ? Colors.red : Colors.greenAccent,
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

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
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
                value: selectedComponentToAdd,
                items: Components.allKeys.map((String key) {
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
            : _buildComponentsTable(),

          buildConfirmButton(onConfirm),
        ],
      ),
    );
  }
}