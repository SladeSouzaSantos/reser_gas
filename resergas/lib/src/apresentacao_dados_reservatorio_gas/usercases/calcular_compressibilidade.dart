import 'dart:math';
import 'package:resergas/src/utils/double_rounding.dart';

class CalcularCompressibilidade {

  static double calcular({required double pressaoPseudoCritica, required double pressaoPseudoReduzida, required double temperaturaPseudoReduzida, required double fatorCompressibilidadeGas}){
    
    return ((1 / (pressaoPseudoReduzida * pressaoPseudoCritica)) + ((1 / (fatorCompressibilidadeGas * pressaoPseudoCritica)) * ((3.52 / (pow(10, (0.9813 * temperaturaPseudoReduzida)))) - ((0.548 * pressaoPseudoReduzida) / (pow(10, (0.8157 * temperaturaPseudoReduzida))))))).roundToDecimalPlaces(6);
  }
}