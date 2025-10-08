import '../../../domain/models/component_fraction.dart';
import '../../domain/models/gas_component_result.dart';

class PercorrerComponentes {
  GasComponentResult pecorrer({required List<ComponentFraction> components}){

    double yMistura = 0;
    double yHidrocarbonetos = 0;
    double yN2 = 0;
    double yH2S = 0;
    double yCO2 = 0;
    double molecularWeightMistura = 0;
    double pseudocriticalPressureMistura = 0;
    double pseudocriticalTemperatureMistura = 0;
    double zCriticoMistura = 0;
    double molecularWeightHidrocarbonetos = 0;
    double pseudocriticalPressureHidrocarbonetos = 0;
    double pseudocriticalTemperatureHidrocarbonetos = 0;
    double zCriticoHidrocarbonetos = 0;    
    double zCriticoN2 = 0;
    double zCriticoH2S = 0;
    double zCriticoCO2 = 0;
    
    for (var componenteFracao in components){
      final fracao = componenteFracao.fraction;

      yMistura += fracao;
      molecularWeightMistura += (componenteFracao.component.molecularWeight)*fracao;
      pseudocriticalPressureMistura += (componenteFracao.component.pseudocriticalPressure)*fracao;
      pseudocriticalTemperatureMistura += (componenteFracao.component.pseudocriticalTemperature)*fracao;
      zCriticoMistura += (componenteFracao.component.criticalZFactor)*fracao;

      if(componenteFracao.component.name == "Nitrogen"){
        yN2 += fracao;
        zCriticoN2 += (componenteFracao.component.criticalZFactor)*fracao;
      }

      else if(componenteFracao.component.name == "HydrogenSulfide"){
        yH2S += fracao;
        zCriticoH2S += (componenteFracao.component.criticalZFactor)*fracao;
      }

      else if(componenteFracao.component.name == "CarbonDioxide"){
        yCO2 += fracao;
        zCriticoCO2 += (componenteFracao.component.criticalZFactor)*fracao;
      }else{
        yHidrocarbonetos += fracao;
        molecularWeightHidrocarbonetos += (componenteFracao.component.molecularWeight)*fracao;
        pseudocriticalPressureHidrocarbonetos += (componenteFracao.component.pseudocriticalPressure)*fracao;
        pseudocriticalTemperatureHidrocarbonetos += (componenteFracao.component.pseudocriticalTemperature)*fracao;
        zCriticoHidrocarbonetos += (componenteFracao.component.criticalZFactor)*fracao;
      }

    }

    return GasComponentResult(
      yMistura: yMistura, 
      molecularWeightMistura: molecularWeightMistura, 
      pseudocriticalPressureMistura: pseudocriticalPressureMistura, 
      pseudocriticalTemperatureMistura: pseudocriticalTemperatureMistura, 
      zCriticoMistura: zCriticoMistura, 
      yN2: yN2, 
      yH2S: yH2S, 
      yCO2: yCO2, 
      zCriticoN2: zCriticoN2, 
      zCriticoH2S: zCriticoH2S, 
      zCriticoCO2: zCriticoCO2,
      molecularWeightHidrocarbonetos: molecularWeightHidrocarbonetos,
      pseudocriticalPressureHidrocarbonetos: pseudocriticalPressureHidrocarbonetos,
      pseudocriticalTemperatureHidrocarbonetos: pseudocriticalTemperatureHidrocarbonetos,
      yHidrocarbonetos: yHidrocarbonetos,
      zCriticoHidrocarbonetos: zCriticoHidrocarbonetos
    );
  }
}