import 'package:flutter/material.dart';
import '../../../domain/models/component_fraction.dart';
import '../../../domain/services/localization_service.dart';
import 'tabela_generica.dart';

// Definindo o tipo da função de tradução para que a fábrica possa aceitar
typedef GetTranslation = String Function(String key);

/// Cria e retorna um widget TabelaDadosGenerica já configurado
/// para exibir dados do tipo ComponentFraction.
TabelaDadosGenerica<ComponentFraction> criarTabelaComponentes({
  required GetTranslation getTranslation,
  required String currentLanguage, 
  required List<ComponentFraction> dados,
  required Function(ComponentFraction) onRemove,
  required double totalFraction,
}) {
  final LocalizationService localizationService = LocalizationService(); 
  
  // 1. Definição das Colunas usando ColunaTabela
  final colunas = [
    ColunaTabela(titulo: getTranslation('cabecalho_componente'), flex: 3),
    ColunaTabela(titulo: getTranslation('cabecalho_fracao'), flex: 2),
    ColunaTabela(titulo: getTranslation('cabecalho_massa_molecular'), flex: 2),
    ColunaTabela(titulo: getTranslation('cabecalho_pc'), flex: 2),
    ColunaTabela(titulo: getTranslation('cabecalho_tc'), flex: 2),
  ];

  // 2. Construtor de Células (CellBuilder)
  Widget componentCellBuilder(ComponentFraction item, int indiceColuna) {
    late String text;
    
    switch (indiceColuna) {
      case 0: // Nome do Componente
        final componentDisplayName = localizationService.getTranslation(item.component.name, currentLanguage);
        text = componentDisplayName.length > 15 
          ? '${componentDisplayName.substring(0, 12)}...'
          : componentDisplayName;
        return Text(
          text, 
          style: const TextStyle(color: Colors.white, fontSize: 12),
        );
      case 1: // Fração
        text = item.fraction.toStringAsFixed(4);
        break;
      case 2: // Massa Molecular
        text = item.component.molecularWeight.toStringAsFixed(3);
        break;
      case 3: // Pressão Crítica (pc)
        text = item.component.pseudocriticalPressure.toStringAsFixed(2);
        break;
      case 4: // Temperatura Crítica (tc)
        text = item.component.pseudocriticalTemperature.toStringAsFixed(2);
        break;
      default:
        text = '';
    }

    return Text(
      text, 
      style: const TextStyle(color: Colors.white70, fontSize: 12),
    );
  }

  // 3. Widget de Rodapé (Footer)
  final rodapeWidget = Row(
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
      // Espaços em branco para alinhar com o restante das colunas
      const Expanded(flex: 2, child: SizedBox()),
      const Expanded(flex: 2, child: SizedBox()),
      const Expanded(flex: 2, child: SizedBox()),
      const Expanded(flex: 2, child: SizedBox()), 
    ],
  );

  // 4. Retorna a instância da TabelaDadosGenerica configurada
  return TabelaDadosGenerica<ComponentFraction>(
    dados: dados,
    colunas: colunas,
    construtorDeCelula: componentCellBuilder,
    aoRemover: onRemove, 
    rodape: rodapeWidget,      
  );
}