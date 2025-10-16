import 'package:resergas/src/utils/double_rounding.dart';

class CalcularCompressibilidadeReduzida {

  static double? calcular({required double pressaoPseudoCritica, required double? compressibilidadeGas}){
    if (compressibilidadeGas == null){
      return null;
    }
    return (compressibilidadeGas*pressaoPseudoCritica).roundToDecimalPlaces(4);
  }

}