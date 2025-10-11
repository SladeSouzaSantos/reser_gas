import 'package:flutter/material.dart';
import 'package:resergas/src/utils/converter_unidades.dart';
import 'package:resergas/src/utils/double_rounding.dart';
import 'dart:math';
import '../../domain/models/gas_reservatorio.dart';
import '../../domain/services/localization_service.dart';
import '../../selecao_dados_gases_entrada/domain/models/gas_component_result.dart';
import '../usercases/calcular_compressibilidade.dart';
import '../usercases/calcular_compressibilidade_reduzida.dart';
import '../usercases/calcular_factor_z.dart';
import '../usercases/calcular_fator_volume_formacao.dart';
import '../usercases/calcular_massa_especifica.dart';
import '../usercases/calcular_propriedades_pseudo_critica_por_densidade.dart';
import '../usercases/calcular_propriedades_pseudo_reduzidas.dart';
import '../usercases/calcular_viscosidade.dart';


typedef GetTranslation = String Function(String key);

class TelaDadosReservatorio extends StatefulWidget {
  final String idiomaSelecionado;
  final GasReservatorio gasInputData;

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
  late GasReservatorio _dadosGas;

  // Unidades disponíveis (keys da LocalizationService)
  final List<String> _pressureUnits = ['unidade_pressao_psia', 'unidade_pressao_kpa', 'unidade_pressao_kgf_cm2', 'unidade_pressao_atm', 'unidade_pressao_bar'];
  final List<String> _temperatureUnits = ['unidade_temperatura_f', 'unidade_temperatura_c', 'unidade_temperatura_k', 'unidade_temperatura_r'];
  
  // Seleção atual
  late String _selectedPressureUnit;
  late String _selectedTemperatureUnit;
  
  late bool _calculationResult;

  @override
  void initState() {
    super.initState();
    _selectedPressureUnit = _pressureUnits.first;
    _selectedTemperatureUnit = _temperatureUnits.first;
    _calculationResult = false;
    
    // Inicializa os dados do reservatório com os dados de entrada
    _dadosGas = widget.gasInputData;

    // Inicia o cálculo da largura após a primeira renderização
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateMaxUnitWidth(context);
    });
  }
  
  String _getTranslation(String key) {
    return _localizationService.getTranslation(key, widget.idiomaSelecionado);
  }
  
  void _calculateMaxUnitWidth(BuildContext context) {
    const textStyle = TextStyle(color: Colors.amber, fontSize: 16);
    double maxWidth = 0.0;
    
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

    final String pressaoText = _pressureController.text.trim();
    double? pressao = double.tryParse(pressaoText.replaceAll(',', '.'));

    final String temperaturaText = _temperatureController.text.trim();
    double? temperatura = double.tryParse(temperaturaText.replaceAll(',', '.'));

    if ((pressao == null || pressao <= 0) || (temperatura == null || temperatura <= 0)) {
      setState(() {
        _calculationResult = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getTranslation('erro_inserir_valores_validos'))),
      );
      return;
    }

    // Lógica de qual cálculo usar (por Massa Molecular, Densidade ou Composição)

    if (_selectedPressureUnit == "unidade_pressao_kpa"){
      pressao = pressao.pressaokPaToPsia();
    }else if (_selectedPressureUnit == "unidade_pressao_kgf_cm2"){
      pressao = pressao.pressaokgfcm2ToPsia();
    }else if (_selectedPressureUnit == "unidade_pressao_atm"){
      pressao = pressao.pressaoatmToPsia();
    }else if (_selectedPressureUnit == "unidade_pressao_bar"){
      pressao = pressao.pressaoatmToPsia();
    }

    if (_selectedTemperatureUnit == "unidade_temperatura_f"){
      temperatura = temperatura.temperaturaFahrenheitToRankine();
    }else if (_selectedTemperatureUnit == "unidade_temperatura_c"){
      temperatura = temperatura.temperaturaCelsiusToRankine();
    }else if (_selectedTemperatureUnit == "unidade_temperatura_k"){
      temperatura = temperatura.temperaturaKelvinToRankine();
    }

    pressao = pressao.roundToDecimalPlaces(4);
    temperatura = temperatura.roundToDecimalPlaces(4);


    GasComponentResult? gasComponents = _dadosGas.gasComponents;
    double pressaoPseudoCritica = 0;
    double temperaturaPseudoCritica = 0;
    double pressaoPseudoReduzida = 0;
    double temperaturaPseudoReduzida = 0;
    double fatorCompressibilidadeGas = 0;
    double massaEspecifica = 0;
    double compressibilidadeGas = 0;
    double compressibilidadeGasReduzido = 0;
    double fatorVolumeFormacao = 0;
    double viscosidade = 0;

    if((gasComponents?.yHidrocarbonetos != null) && (gasComponents?.yHidrocarbonetos != 0)){

      pressaoPseudoCritica = (gasComponents!.pseudocriticalPressureMistura).roundToDecimalPlaces(2);
      temperaturaPseudoCritica = (gasComponents.pseudocriticalTemperatureMistura).roundToDecimalPlaces(2);
      (pressaoPseudoReduzida, temperaturaPseudoReduzida) = CalcularPropriedadesPseudoReduzidas.calcular(pressao: pressao, temperatura: temperatura, pressaoPseudoCritica: pressaoPseudoCritica, temperaturaPseudoCritica: temperaturaPseudoCritica);
      fatorCompressibilidadeGas = (CalcularFactorZ().calcular(ppr: pressaoPseudoReduzida, tpr: temperaturaPseudoReduzida));      
    } else{

      (pressaoPseudoCritica, temperaturaPseudoCritica) = CalcularPropriedadesPseudoCriticaPorDensidade.calcular(dg: _dadosGas.gasDensity!,
        gasTipo: _dadosGas.gasClassification!,
        yCO2: gasComponents == null ? 0 : gasComponents.yCO2,
        yH2S: gasComponents == null ? 0 : gasComponents.yH2S,
        yN2: gasComponents == null ? 0 : gasComponents.yN2);

      (pressaoPseudoReduzida, temperaturaPseudoReduzida) = CalcularPropriedadesPseudoReduzidas.calcular(pressao: pressao, temperatura: temperatura, pressaoPseudoCritica: pressaoPseudoCritica, temperaturaPseudoCritica: temperaturaPseudoCritica);
      
      fatorCompressibilidadeGas = (CalcularFactorZ().calcular(ppr: pressaoPseudoReduzida, tpr: temperaturaPseudoReduzida));
      
    }

    massaEspecifica = (CalcularMassaEspecifica.calcular(pressao: pressao, molecularWeight: _dadosGas.molecularWeight!, fatorCompressibilidadeGas: fatorCompressibilidadeGas, temperatura: temperatura));

    compressibilidadeGas = CalcularCompressibilidade.calcular(pressaoPseudoCritica: pressaoPseudoCritica, pressaoPseudoReduzida: pressaoPseudoReduzida, temperaturaPseudoReduzida: temperaturaPseudoReduzida, fatorCompressibilidadeGas: fatorCompressibilidadeGas);

    compressibilidadeGasReduzido = CalcularCompressibilidadeReduzida.calcular(pressaoPseudoCritica: pressaoPseudoCritica, compressibilidadeGas: compressibilidadeGas);

    fatorVolumeFormacao = CalcularFatorVolumeFormacao.calcular(pressao: pressao, temperatura: temperatura, fatorCompressibilidadeGas: fatorCompressibilidadeGas);

    viscosidade = CalcularViscosidade.calcular(pressaoPseudoReduzida: pressaoPseudoReduzida, temperaturaPseudoReduzida: temperaturaPseudoReduzida, temperatura: temperatura, gasDensity: _dadosGas.gasDensity!, yH2S: gasComponents == null ? 0 : gasComponents.yH2S, yCO2: gasComponents == null ? 0 : gasComponents.yCO2, yN2: gasComponents == null ? 0 : gasComponents.yN2);
    
    setState(() {
      _calculationResult = true;
      _dadosGas = GasReservatorio(
          reservoirPressure: pressao,
          reservoirTemperature: temperatura,
          gasDensity: _dadosGas.gasDensity,
          molecularWeight: _dadosGas.molecularWeight!,
          gasClassification: _dadosGas.gasClassification,
          pseudocriticalPressure: pressaoPseudoCritica,
          pseudocriticalTemperature: temperaturaPseudoCritica,
          pseudoreducedPressure: pressaoPseudoReduzida,
          pseudoreducedTemperature: temperaturaPseudoReduzida,
          compressibilityFactor: fatorCompressibilidadeGas,
          gasSpecificGravity: massaEspecifica,
          compressibility: compressibilidadeGas,
          reducedCompressibility: compressibilidadeGasReduzido,
          gasVolumeFactor: fatorVolumeFormacao,
          gasViscosity: viscosidade,
          gasComponents: gasComponents
      );
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
        // TRADUÇÃO APLICADA: labelText
        labelText: _getTranslation(labelKey), 
        labelStyle: const TextStyle(color: Colors.amber),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        
        // Seletor de unidade integrado (Sufixo)
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SizedBox( 
            width: _maxUnitWidth,
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
                      // TRADUÇÃO APLICADA: Opções do Dropdown
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
    // TRADUÇÃO APLICADA: Unidade e 'N/A'
    final String unit = unitKey.isEmpty ? '' : _getTranslation(unitKey);
    final String naText = _getTranslation('N/A'); // Sugestão de chave 'N/A'
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Lado Esquerdo: Rótulo da Propriedade (Ex: 'Pressão Pseudocrítica (Ppc):')
          Expanded(
            child: Text(
              // TRADUÇÃO APLICADA: Rótulo da Propriedade
              '${_getTranslation(propKey)}:', 
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          
          // Lado Direito: Valor e Unidade
          Text(
            value != null ? '$value $unit' : naText,
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
          // TRADUÇÃO APLICADA: Texto do Botão
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
    if (_maxUnitWidth == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        // TRADUÇÃO APLICADA: Título da AppBar
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
                  
                  // Entrada de Pressão (label_pressao_reservatorio já está traduzida)
                  _buildInputWithUnitSelector(
                    labelKey: 'label_pressao_reservatorio',
                    controller: _pressureController,
                    selectedUnit: _selectedPressureUnit,
                    units: _pressureUnits,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPressureUnit = newValue!;
                        _calculateMaxUnitWidth(context); 
                      });
                    },
                  ),

                  const SizedBox(height: 32),

                  // Entrada de Temperatura (label_temperatura_reservatorio já está traduzida)
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
                  if (_calculationResult) ...[
                    const SizedBox(height: 48),
                    const Divider(color: Colors.amber),
                    const SizedBox(height: 16),
                    
                    // Título dos Resultados
                    Text(
                      // TRADUÇÃO APLICADA: Título dos Resultados
                      _getTranslation('propriedades_calculadas'),
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    // Exibição das propriedades (prop_ppc, prop_tpc, etc., já estão traduzidas nas chamadas)
                    _buildPropertyRow('label_pressao_reservatorio', _dadosGas.reservoirPressure, 'unidade_pressao_psia'),
                    _buildPropertyRow('label_temperatura_reservatorio', _dadosGas.reservoirTemperature, 'unidade_temperatura_r'),
                    _buildPropertyRow('prop_massa_molecular', _dadosGas.molecularWeight, 'unidade_massa_molecular'),
                    _buildPropertyRow('prop_densidade', _dadosGas.gasDensity, 'unidade_adimensional'),
                    _buildPropertyRow('prop_ppc', _dadosGas.pseudocriticalPressure, 'unidade_pressao_psia'),
                    _buildPropertyRow('prop_tpc', _dadosGas.pseudocriticalTemperature, 'unidade_temperatura_r'),
                    _buildPropertyRow('prop_ppr', _dadosGas.pseudoreducedPressure, 'unidade_adimensional'),
                    _buildPropertyRow('prop_tpr', _dadosGas.pseudoreducedTemperature, 'unidade_adimensional'),
                    _buildPropertyRow('prop_fator_compressibilidade', _dadosGas.compressibilityFactor, 'unidade_adimensional'),
                    _buildPropertyRow('prop_massa_especifica', _dadosGas.gasSpecificGravity, 'unidade_massa_especifica'),
                    _buildPropertyRow('prop_viscosidade', _dadosGas.gasViscosity, 'unidade_viscosidade'),                    
                    _buildPropertyRow('prop_compressibilidade', _dadosGas.compressibility, 'unidade_compressibilidade'),                    
                    _buildPropertyRow('prop_compressibilidade_reduzida', _dadosGas.reducedCompressibility, 'unidade_adimensional'),
                    _buildPropertyRow('prop_fator_volume_formacao', _dadosGas.gasVolumeFactor, 'unidade_fator_volume_formacao'),
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