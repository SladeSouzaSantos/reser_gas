import 'package:flutter/material.dart';
import 'dart:math';

import '../../selecao_dados_gases_entrada/domain/models/gas_input_data.dart';
import '../../domain/services/localization_service.dart';

// Definindo os tipos de dados
typedef GetTranslation = String Function(String key);

// Estrutura para os resultados de cálculo (simplesmente para demonstrar)
class GasPropertiesResult {
  // Para fins de demonstração, valores fixos (serão calculados na versão final)
  final double ppc = 670.0; 
  final double tpc = 360.0;
  final double ppr = 0.85; 
  final double tpr = 1.15; 
  final double molecularWeight = 20.0;
  final double massaEspecifica = 1.5; // kg/m3 (Ex: 1.5)
  final double densidade = 0.70; // (Ex: 0.70)
  final double viscosidade = 0.015; // cP (Ex: 0.015)
  final double compressibilidade = 1.5e-4; // 1/psi (Ex: 1.5E-4)
  final double compressibilidadeReduzida = 0.12; // (Ex: 0.12)
  final double fatorCompressibilidade = 0.89; // (Ex: 0.89)
  final double fatorVolumeFormacao = 0.005; // ft3/scf (Ex: 0.005)

  const GasPropertiesResult();
}

class TelaDadosReservatorio extends StatefulWidget {
  final String idiomaSelecionado;
  final GasInputData gasInputData;

  const TelaDadosReservatorio({
    super.key,
    required this.idiomaSelecionado,
    required this.gasInputData,
  });

  @override
  State<TelaDadosReservatorio> createState() => _TelaDadosReservatorioState();
}

class _TelaDadosReservatorioState extends State<TelaDadosReservatorio> {
  final LocalizationService _localizationService = LocalizationService();
  final TextEditingController _pressureController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  
  // Variável para armazenar a largura máxima calculada
  double? _maxUnitWidth; 

  // Unidades disponíveis (keys da LocalizationService)
  final List<String> _pressureUnits = ['unidade_pressao_psia', 'unidade_pressao_kpa', 'unidade_pressao_kgf_cm2', 'unidade_pressao_atm', 'unidade_pressao_bar'];
  final List<String> _temperatureUnits = ['unidade_temperatura_f', 'unidade_temperatura_c', 'unidade_temperatura_k', 'unidade_temperatura_r'];
  
  // Seleção atual
  late String _selectedPressureUnit;
  late String _selectedTemperatureUnit;

  // Resultado do cálculo
  GasPropertiesResult? _calculationResult;

  @override
  void initState() {
    super.initState();
    _selectedPressureUnit = _pressureUnits.first;
    _selectedTemperatureUnit = _temperatureUnits.first;
    
    // Inicia o cálculo da largura após a primeira renderização
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateMaxUnitWidth(context);
    });
  }
  
  // Função auxiliar para tradução
  String _getTranslation(String key) {
    return _localizationService.getTranslation(key, widget.idiomaSelecionado);
  }

  // NOVO MÉTODO: Calcula a largura necessária para o texto da unidade mais longa
  void _calculateMaxUnitWidth(BuildContext context) {
    const textStyle = TextStyle(color: Colors.amber, fontSize: 16);
    double maxWidth = 0.0;

    // Combina todas as unidades para encontrar a mais longa
    final allUnitsKeys = {..._pressureUnits, ..._temperatureUnits}.toSet();

    for (var key in allUnitsKeys) {
      final unitText = _getTranslation(key);
      final textPainter = TextPainter(
        text: TextSpan(text: unitText, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      
      // 30.0 é uma margem de segurança para o ícone da seta e padding interno
      maxWidth = max(maxWidth, textPainter.width + 30.0); 
    }

    if (maxWidth != _maxUnitWidth && maxWidth > 0) {
      setState(() {
        _maxUnitWidth = maxWidth;
      });
    }
  }


  // Função placeholder para o cálculo
  void _calculateGasProperties() {
    if (_pressureController.text.isEmpty || _temperatureController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira todos os valores.')),
      );
      return;
    }
    
    setState(() {
      _calculationResult = const GasPropertiesResult();
    });
  }

  // Bloco de entrada de Pressão/Temperatura com seletor de unidade integrado
  Widget _buildInputWithUnitSelector({
    required String labelKey,
    required TextEditingController controller,
    required String selectedUnit,
    required List<String> units,
    required ValueChanged<String?> onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: _getTranslation(labelKey),
        labelStyle: const TextStyle(color: Colors.amber),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        
        // Seletor de unidade integrado (Sufixo)
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          // Usa SizedBox com largura calculada (_maxUnitWidth) para forçar o alinhamento
          child: SizedBox( 
            width: _maxUnitWidth, // Pode ser nulo na primeira construção, mas o setState recalcula
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedUnit,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.amber, fontSize: 16),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.amber),
                onChanged: onChanged,
                isExpanded: true, 
                items: units.map<DropdownMenuItem<String>>((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(
                      _getTranslation(key),
                      textAlign: TextAlign.right,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Bloco de exibição de uma propriedade (nome, símbolo, valor, unidade)
  Widget _buildPropertyRow(String propKey, double? value, String unitKey) { 
    final String unit = unitKey.isEmpty ? '' : _getTranslation(unitKey);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Lado Esquerdo: Rótulo da Propriedade (Ex: 'Pressão Pseudocrítica (Ppc):')
          Expanded(
            child: Text(
              '${_getTranslation(propKey)}:', 
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          
          // Lado Direito: Valor e Unidade
          Text(
            value != null ? '${value.toStringAsFixed(4)} $unit' : 'N/A',
            style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  
  // Botão de Calcular
  Widget _buildCalculateButton() {
    return InkWell(
      onTap: _calculateGasProperties,
      borderRadius: BorderRadius.circular(25.0),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.amber, 
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Text(
          _getTranslation('botao_calcular'),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Se a largura não foi calculada, exibimos um Container vazio temporariamente.
    // Isso é uma medida de segurança, pois o cálculo é feito no WidgetsBinding.
    if (_maxUnitWidth == null) {
      // Poderia ser um loading spinner, mas para manter a simplicidade:
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        title: Text(_getTranslation('tela_reservatorio_titulo'), style: const TextStyle(color: Colors.white, fontSize: 18)),         
      ),
      backgroundColor: Colors.black, 
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600), 
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E), 
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  // --- ENTRADA DE PRESSÃO E TEMPERATURA ---
                  
                  // Entrada de Pressão
                  _buildInputWithUnitSelector(
                    labelKey: 'label_pressao_reservatorio',
                    controller: _pressureController,
                    selectedUnit: _selectedPressureUnit,
                    units: _pressureUnits,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPressureUnit = newValue!;
                        // Recalcular largura caso mude o idioma (embora seja improvável aqui)
                        _calculateMaxUnitWidth(context); 
                      });
                    },
                  ),

                  const SizedBox(height: 32),

                  // Entrada de Temperatura
                  _buildInputWithUnitSelector(
                    labelKey: 'label_temperatura_reservatorio',
                    controller: _temperatureController,
                    selectedUnit: _selectedTemperatureUnit,
                    units: _temperatureUnits,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTemperatureUnit = newValue!;
                        _calculateMaxUnitWidth(context);
                      });
                    },
                  ),
                  
                  const SizedBox(height: 48),

                  // --- BOTÃO CALCULAR ---
                  Center(child: _buildCalculateButton()),

                  // --- RESULTADOS ---
                  if (_calculationResult != null) ...[
                    const SizedBox(height: 48),
                    const Divider(color: Colors.amber),
                    const SizedBox(height: 16),
                    
                    // Título dos Resultados
                    Text(
                      _getTranslation('propriedades_calculadas'),
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    // Exibição das propriedades
                    _buildPropertyRow('prop_ppc', widget.gasInputData.pseudocriticalPressure, 'unidade_pressao_psia'),
                    _buildPropertyRow('prop_ppr', _calculationResult!.ppr, 'unidade_adimensional'),
                    
                    _buildPropertyRow('prop_tpc', widget.gasInputData.pseudocriticalTemperature, 'unidade_temperatura_r'),
                    _buildPropertyRow('prop_tpr', _calculationResult!.tpr, 'unidade_adimensional'),
                    
                    _buildPropertyRow('prop_massa_molecular', widget.gasInputData.molecularWeight, 'unidade_massa_molecular'),
                    
                    _buildPropertyRow('prop_massa_especifica', _calculationResult!.massaEspecifica, 'unidade_massa_especifica'),
                    
                    _buildPropertyRow('prop_densidade', _calculationResult!.densidade, 'unidade_adimensional'),
                    
                    _buildPropertyRow('prop_viscosidade', _calculationResult!.viscosidade, 'unidade_viscosidade'),
                    
                    _buildPropertyRow('prop_compressibilidade', _calculationResult!.compressibilidade, 'unidade_compressibilidade'),
                    
                    _buildPropertyRow('prop_compressibilidade_reduzida', _calculationResult!.compressibilidadeReduzida, 'unidade_adimensional'),
                    
                    _buildPropertyRow('prop_fator_compressibilidade', _calculationResult!.fatorCompressibilidade, 'unidade_adimensional'),
                    
                    _buildPropertyRow('prop_fator_volume_formacao', _calculationResult!.fatorVolumeFormacao, 'unidade_fator_volume_formacao'),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}