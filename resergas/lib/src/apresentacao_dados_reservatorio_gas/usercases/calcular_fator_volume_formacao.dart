import 'package:resergas/src/utils/double_rounding.dart';

class CalcularFatorVolumeFormacao {
  static double calcular({required double pressao, required double temperatura, required double fatorCompressibilidadeGas}){
    return ((14.7/519.67)*((fatorCompressibilidadeGas*temperatura)/pressao)).roundToDecimalPlaces(6);
  }
}