class GasInputData {
  final double molecularWeight; // Massa Molecular média (MBar)
  final double pseudocriticalPressure; // Pressão Pseudo Crítica (Ppc)
  final double pseudocriticalTemperature; // Temperatura Pseudo Crítica (Tpc)

  const GasInputData({
    required this.molecularWeight,
    required this.pseudocriticalPressure,
    required this.pseudocriticalTemperature,
  });
}