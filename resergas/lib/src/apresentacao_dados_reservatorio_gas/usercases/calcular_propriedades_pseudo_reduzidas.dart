import 'package:resergas/src/utils/double_rounding.dart';

class CalcularPropriedadesPseudoReduzidas {

  static (double, double) calcular({required double pressao, required double temperatura, required double pressaoPseudoCritica, required double temperaturaPseudoCritica}){

    double pressaoPseudoReduzida = (pressao/pressaoPseudoCritica);
    double temperaturaPseudoReduzida = (temperatura/temperaturaPseudoCritica);

    return (pressaoPseudoReduzida.roundToDecimalPlaces(2), temperaturaPseudoReduzida.roundToDecimalPlaces(2));
  }

}