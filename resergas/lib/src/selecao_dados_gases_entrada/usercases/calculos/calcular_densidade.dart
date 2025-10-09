import 'package:resergas/src/utils/double_rounding.dart';

class CalcularDensidade {
  
  (double, String) calcular({required double massaMolecular}){
    final double dg = (massaMolecular/28.966);
    final String tipo = dg <= 0.7 ? "Seco" : "Úmido";
    
    return (dg.roundToDecimalPlaces(3), tipo);
  }

}