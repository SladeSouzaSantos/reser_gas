import 'dart:math';

import 'package:resergas/src/utils/double_rounding.dart';

class CalcularPropriedadesPseudoCritica {

  static (double, double) calcular({required String gasTipo, required double dg, required double yCO2, required double yH2S, required double yN2}){

    if((yH2S != 0) || (yH2S != 0) || (yH2S != 0)){
      dg = ((dg - (0.967*yN2) - (1.52*yCO2) - (1.18*yH2S))/(1 - yCO2 - yH2S - yN2));
    }

    double pressaoPseudoCritica = (gasTipo == "Seco") ? (677 + (15 * dg) - (37.5 * pow(dg, 2))) : (706 + (51.7 * dg) - (11.1 * pow(dg, 2)));

    double temperaturaPseudoCritica = (gasTipo == "Seco") ? (168 + (325 * dg) - (12.5 * pow(dg, 2))) : (187 + (330 * dg) - (71.5 * pow(dg, 2)));

    if((yH2S != 0) || (yH2S != 0) || (yH2S != 0)){
      final eGasAcido = (120 * ((pow((yCO2 + yH2S), 0.9)) - (pow((yCO2 + yH2S), 1.6)))) + (15 * ((pow(yH2S, 0.5)) - (pow(yH2S, 4))));

      final pressaoPseudoCriticaMistura = ((1 - yN2 - yCO2 - yH2S)*pressaoPseudoCritica) + (493*yN2) + (1071*yCO2) + (1306*yH2S);

      final temperaturaPseudoCriticaMistura = ((1 - yN2 - yCO2 - yH2S)*temperaturaPseudoCritica) + (227*yN2) + (548*yCO2) + (672*yH2S);

      pressaoPseudoCritica = (pressaoPseudoCriticaMistura*(temperaturaPseudoCriticaMistura - eGasAcido))/((temperaturaPseudoCriticaMistura) + (yH2S*pow((1-yH2S), eGasAcido)));
      
      temperaturaPseudoCritica = temperaturaPseudoCriticaMistura - eGasAcido;
    }
    
    return (pressaoPseudoCritica.roundToDecimalPlaces(2), temperaturaPseudoCritica.roundToDecimalPlaces(2));
  }
}