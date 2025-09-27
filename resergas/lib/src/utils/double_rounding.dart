import 'dart:math';

extension DoubleRounding on double {

  double roundToDecimalPlaces(int decimalPlaces) {
    
    if (decimalPlaces < 0) {
      throw ArgumentError('O número de casas decimais não pode ser negativo.');
    }    
    
    final factor = pow(10, decimalPlaces).toDouble();
    
    final multiplied = this * factor;

    final rounded = multiplied.round();
    
    final result = rounded / factor;

    return result;

  }
}