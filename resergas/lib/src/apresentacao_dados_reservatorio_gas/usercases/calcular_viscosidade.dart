import 'dart:math';

import 'package:resergas/src/utils/double_rounding.dart';
import 'package:resergas/src/utils/log10.dart';

class CalcularViscosidade {

  static double calcular({required double pressaoPseudoReduzida, required double temperaturaPseudoReduzida, required double temperatura, required double gasDensity, required double yH2S, required double yCO2, required double yN2}){
    
    double a0 = -2.46211820;
    double a1 = 2.97054714;
    double a2 = -2.86264054 * pow(10, -1);
    double a3 = 8.05420522 * pow(10, -3);
    double a4 = 2.80860949;
    double a5 = -3.49803305;
    double a6 = 3.60373020 * pow(10, -1);
    double a7 = -1.04432413 * pow(10, -2);
    double a8 = -7.93385684 * pow(10, -1);
    double a9 = 1.39643306;
    double a10 = -1.49144925 * pow(10, -1);
    double a11 = 4.41015512 * pow(10, -3);
    double a12 = 8.39387178 * pow(10, -2);
    double a13 = -1.86408848 * pow(10, -1);
    double a14 = 2.03367881 * pow(10, -2);
    double a15 = -6.09579263 * pow(10, -4);

    final mic = (a0 + (a1 * pressaoPseudoReduzida) + (a2 * pow(pressaoPseudoReduzida, 2)) + (a3 * pow(pressaoPseudoReduzida, 3)) + (temperaturaPseudoReduzida * (a4 + (a5 * pressaoPseudoReduzida) + (a6 * pow(pressaoPseudoReduzida, 2)) + (a7 * pow(pressaoPseudoReduzida, 3)))) + (pow(temperaturaPseudoReduzida, 2) * (a8 + (a9 * pressaoPseudoReduzida) + (a10 * pow(pressaoPseudoReduzida, 2)) +( a11 * pow(pressaoPseudoReduzida, 3)))) + (pow(temperaturaPseudoReduzida, 3) * (a12 + (a13 * pressaoPseudoReduzida) + (a14 * pow(pressaoPseudoReduzida, 2)) + (a15 * pow(pressaoPseudoReduzida, 3)))));

    final mi1c = ((temperatura - 459.67) * ((1.709 * pow(10, -5)) - (2.062 * gasDensity * pow(10, -6)))) + (8.188 * pow(10, -3)) - (6.15 * gasDensity.log10() * pow(10, -3));

    final min2 = yN2 * ((8.48 * pow(10, -3) * gasDensity.log10()) + (9.59 * pow(10, -3)));

    final mico2 = yCO2 * ((9.08 * pow(10, -3) * gasDensity.log10()) + (6.24 * pow(10, -3)));

    final mih2s = yH2S * ((8.49 * pow(10, -3) * gasDensity.log10()) + (3.73 * pow(10, -3)));

    final mi1 = mi1c + min2 + mico2 + mih2s;

    final mi = (mi1 * exp(mic)) / temperaturaPseudoReduzida;

    return mi.roundToDecimalPlaces(6);
  }

}