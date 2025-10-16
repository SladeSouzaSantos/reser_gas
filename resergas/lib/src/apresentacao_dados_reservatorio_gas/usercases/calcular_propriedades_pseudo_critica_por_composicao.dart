import 'package:resergas/src/utils/double_rounding.dart';

class CalcularPropriedadesPseudoCriticaPorComposicao {

  static (double, double) calcular({required double pressaoPseudoCriticaHidrocarboneto, required double temperaturaPseudoCriticaHidrocarboneto, required double fracaoHidrocarboneto}){

    double pressaoPseudoCritica = pressaoPseudoCriticaHidrocarboneto;
    double temperaturaPseudoCritica = temperaturaPseudoCriticaHidrocarboneto;
    
    if(fracaoHidrocarboneto != 0){
      pressaoPseudoCritica = pressaoPseudoCriticaHidrocarboneto/fracaoHidrocarboneto;
      temperaturaPseudoCritica = temperaturaPseudoCriticaHidrocarboneto/fracaoHidrocarboneto;
    }else{
      return throw ArgumentError('A fração do componente deve ser maior que zero (0).');
    }
    
    return (pressaoPseudoCritica.roundToDecimalPlaces(2), temperaturaPseudoCritica.roundToDecimalPlaces(2));
  }
}