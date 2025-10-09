import 'package:resergas/src/utils/double_rounding.dart';

class CalcularMassaMolecular {
  
  double calcular({required double densidade}){
    return (densidade*28.966).roundToDecimalPlaces(2);
  }
  
}