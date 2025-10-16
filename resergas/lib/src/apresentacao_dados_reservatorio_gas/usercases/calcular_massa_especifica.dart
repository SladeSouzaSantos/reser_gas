import 'package:resergas/src/utils/double_rounding.dart';

class CalcularMassaEspecifica {

  static double? calcular({required double pressao, required double molecularWeight, required double? fatorCompressibilidadeGas, required double temperatura}){
    if ((fatorCompressibilidadeGas != null) && temperatura != 0) {
      return ((pressao*molecularWeight)/(10.73*fatorCompressibilidadeGas*temperatura)).roundToDecimalPlaces(2);
    }
    
    return null;
  }

}