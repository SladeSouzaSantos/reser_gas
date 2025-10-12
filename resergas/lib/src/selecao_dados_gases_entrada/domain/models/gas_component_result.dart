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
  double pseudocriticalPressureN2;
  double pseudocriticalTemperatureN2;    
  double zCriticoN2;
  double pseudocriticalPressureH2S;
  double pseudocriticalTemperatureH2S; 
  double zCriticoH2S;
  double pseudocriticalPressureCO2;
  double pseudocriticalTemperatureCO2; 
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
      required this.pseudocriticalPressureN2,
      required this.pseudocriticalTemperatureN2,
      required this.pseudocriticalPressureH2S,
      required this.pseudocriticalTemperatureH2S,
      required this.pseudocriticalPressureCO2,
      required this.pseudocriticalTemperatureCO2,
      required this.zCriticoN2,
      required this.zCriticoH2S,
      required this.zCriticoCO2
    }
  );
}