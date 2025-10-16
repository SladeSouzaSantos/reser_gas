import 'dart:math';

import 'package:resergas/src/utils/double_rounding.dart';

// ====================================================================
// CÁLCULO DA CORRELAÇÃO DRANCHUK E ABOU-KASSEM
// ====================================================================
class CalcularFactorZ {

  static double? calcular({required double ppr, required double tpr}){

    const double a1 = 0.3265;
    const double a2 = -1.0700;
    const double a3 = -0.5339;
    const double a4 = 0.01569;
    const double a5 = -0.05165;
    const double a6 = 0.5475;
    const double a7 = -0.7361;
    const double a8 = 0.1844;
    const double a9 = 0.1056;
    const double a10 = 0.6134;
    const double a11 = 0.7210;

    double z = 0;
    double zChute = 1;
    double ro;

    int interacoes = 0;

    while((((z - zChute).abs()) == 1) || (((z - zChute).abs()) > 0.000001)){

      if(z != 0 || zChute != 1){
        zChute = z;
      }

      ro = ((0.27*ppr)/(zChute*tpr));

      z = ((1)
      + (((a1) + (a2/tpr) + (a3/pow(tpr, 3)) + (a4/pow(tpr, 4)) + (a5/pow(tpr, 5))) * ro) 
      + (((a6) + (a7/tpr) + (a8/pow(tpr, 2))) * (pow(ro, 2))) 
      - ((a9) * ((a7/tpr) + (a8/pow(tpr, 2))) * (pow(ro, 5))) 
      + ((a10) * ((1) + (a11*pow(ro, 2))) * ((pow(ro, 2)/pow(tpr, 3)) * (pow(e, (-a11 * pow(ro, 2)))))));

      interacoes++;

      if(interacoes == 1000) return null;

    }

    return z.roundToDecimalPlaces(4);
  }

}