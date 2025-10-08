class GasComponentResult{
  double yMistura;
  double yHidrocarbonetos;
  double yN2;
  double yH2S;
  double yCO2;
  double molecularWeightMistura;
  double pseudocriticalPressureMistura;
  double pseudocriticalTemperatureMistura;
  double zCriticoMistura;
  double molecularWeightHidrocarbonetos;
  double pseudocriticalPressureHidrocarbonetos;
  double pseudocriticalTemperatureHidrocarbonetos;
  double zCriticoHidrocarbonetos;    
  double zCriticoN2;
  double zCriticoH2S;
  double zCriticoCO2;

  GasComponentResult(
    {
      required this.yMistura,
      required this.yHidrocarbonetos,
      required this.yN2,
      required this.yH2S,
      required this.yCO2,
      required this.molecularWeightMistura,
      required this.pseudocriticalPressureMistura,
      required this.pseudocriticalTemperatureMistura,
      required this.zCriticoMistura,
      required this.molecularWeightHidrocarbonetos,
      required this.pseudocriticalPressureHidrocarbonetos,
      required this.pseudocriticalTemperatureHidrocarbonetos,
      required this.zCriticoHidrocarbonetos,    
      required this.zCriticoN2,
      required this.zCriticoH2S,
      required this.zCriticoCO2
    }
  );
}