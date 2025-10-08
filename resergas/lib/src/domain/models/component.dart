class Component {
  final String name;
  final double molecularWeight;
  final double pseudocriticalPressure;
  final double pseudocriticalTemperature;
  final double criticalZFactor;

  const Component({
    required this.name,
    required this.molecularWeight,
    required this.pseudocriticalPressure,
    required this.pseudocriticalTemperature,
    required this.criticalZFactor,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'mw': molecularWeight,
    'ppc': pseudocriticalPressure,
    'tpc': pseudocriticalTemperature,
    'z' : criticalZFactor,
  };

  factory Component.fromJson(Map<String, dynamic> json) {
    return Component(
      name: json['name'] as String,
      molecularWeight: (json['mw'] as num).toDouble(),
      pseudocriticalPressure: (json['ppc'] as num).toDouble(),
      pseudocriticalTemperature: (json['tpc'] as num).toDouble(),
      criticalZFactor: (json['z'] as num).toDouble(),
    );
  }
}