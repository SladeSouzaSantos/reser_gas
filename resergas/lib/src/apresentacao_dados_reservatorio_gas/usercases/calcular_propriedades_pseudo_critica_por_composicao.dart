import 'package:resergas/src/utils/double_rounding.dart';

class CalcularPropriedadesPseudoCriticaPorComposicao {

  static (double, double) calcular({required double pressaoPseudoCriticaHidrocarboneto, required double temperaturaPseudoCriticaHidrocarboneto, required double fracaoHidrocarboneto}){

    double pressaoPseudoCritica = pressaoPseudoCriticaHidrocarboneto/fracaoHidrocarboneto;
    double temperaturaPseudoCritica = temperaturaPseudoCriticaHidrocarboneto/fracaoHidrocarboneto;
    
    return (pressaoPseudoCritica.roundToDecimalPlaces(2), temperaturaPseudoCritica.roundToDecimalPlaces(2));
  }
}