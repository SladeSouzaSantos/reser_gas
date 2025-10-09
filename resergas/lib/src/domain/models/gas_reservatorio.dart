import '../../selecao_dados_gases_entrada/domain/models/gas_component_result.dart';

class GasReservatorio {
  final String? gasClassification;

  final GasComponentResult? gasComponents;
  
  final double? molecularWeight; // Massa Molecular média (MBar)
  final double? pseudocriticalPressure; // Pressão Pseudo Crítica (Ppc)
  final double? pseudocriticalTemperature; // Temperatura Pseudo Crítica (Tpc)
  final double? reservoirPressure;   // Pressão do Reservatório (Pr)
  final double? reservoirTemperature; // Temperatura do Reservatório (Tr)
  final double? pseudoreducedPressure;   // Pressão Pseudo Reduzida (Ppr)
  final double? pseudoreducedTemperature;  // Temperatura Pseudo Reduzida (Tpr)
  final double? compressibilityFactor;     // Fator de Compressibilidade (z)
  final double? gasVolumeFactor;           // Fator Volume-Formação do Gás (Bg)
  final double? gasViscosity;              // Viscosidade do Gás (μg)
  final double? gasDensity;                // Densidade do Gás (ρg)
  final double? gasSpecificGravity;        // Gravidade Específica do Gás (γg)
  final double? compressibility; // Compressibilidade (cg)
  final double? reducedCompressibility; // Compressibilidade Reduzida (cr)

  const GasReservatorio({
    this.gasClassification,
    this.gasComponents,
    this.molecularWeight,
    this.pseudocriticalPressure,
    this.pseudocriticalTemperature,
    this.reservoirPressure,
    this.reservoirTemperature,
    this.pseudoreducedPressure,
    this.pseudoreducedTemperature,
    this.compressibilityFactor,
    this.gasVolumeFactor,
    this.gasViscosity,
    this.gasDensity,
    this.gasSpecificGravity,
    this.compressibility,
    this.reducedCompressibility,
  });

  // --- CONVERSÃO PARA MAP (JSON) ---
  Map<String, dynamic> toJson() => {
    'gas_classification': gasClassification,
    'gas_components': gasComponents,
    'ma': molecularWeight,
    'ppc': pseudocriticalPressure,
    'tpc': pseudocriticalTemperature,
    'p': reservoirPressure,
    't': reservoirTemperature,
    'ppr': pseudoreducedPressure,
    'tpr': pseudoreducedTemperature,
    'z': compressibilityFactor,
    'bg': gasVolumeFactor,
    'mi_g': gasViscosity,
    'rho_g': gasDensity,
    'gamma_g': gasSpecificGravity,
    'cg': compressibility,
    'cr': reducedCompressibility,
  };


  // --- CRIAÇÃO A PARTIR DE MAP (FROM JSON) ---
  factory GasReservatorio.fromJson(Map<String, dynamic> json) {        
    return GasReservatorio(
      gasClassification: json['gas_classification'] as String?,
      gasComponents: json['gas_components'],
      molecularWeight: json['ma'] as double?,
      pseudocriticalPressure: json['ppc'] as double?,
      pseudocriticalTemperature: json['tpc'] as double?,
      reservoirPressure: json['p'] as double?,
      reservoirTemperature: json['t'] as double?,
      pseudoreducedPressure: json['ppr'] as double?,
      pseudoreducedTemperature: json['tpr'] as double?,
      compressibilityFactor: json['z'] as double?,
      gasVolumeFactor: json['bg'] as double?,
      gasViscosity: json['mi_g'] as double?,
      gasDensity: json['rho_g'] as double?,
      gasSpecificGravity: json['gamma_g'] as double?,
      compressibility: json['cg'] as double?,
      reducedCompressibility: json['cr'] as double?,
    );
  }
}