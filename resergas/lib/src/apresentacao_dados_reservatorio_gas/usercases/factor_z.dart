import 'dart:math';

import 'package:resergas/src/utils/double_rounding.dart';

// ====================================================================
// CONSTANTES DA CORRELAÇÃO DRANCHUK E ABOU-KASSEM
// ====================================================================
class A {
  static const double a1 = 0.3265;
  static const double a2 = -1.0700;
  static const double a3 = -0.5339;
  static const double a4 = 0.01569;
  static const double a5 = -0.05165;
  static const double a6 = 0.5475;
  static const double a7 = -0.7361;
  static const double a8 = 0.1844;
  static const double a9 = 0.1056;
  static const double a10 = 0.6134;
  static const double a11 = 0.7210;
}


// ====================================================================
// CÁLCULO DA CORRELAÇÃO DRANCHUK E ABOU-KASSEM
// ====================================================================
class FactorZ {

  double calcular({required double ppr, required double tpr}){

    double z = 0;
    double zChute = 1;
    double ro;

    while((((z - zChute).abs()) == 1) || (((z - zChute).abs()) > 0.0009)){
      
      if(z != 0 || zChute != 1){
        zChute = z;
      }

      ro = ((0.27*ppr)/(zChute*tpr));

      z = ((1)
      + (((A.a1) + (A.a2/tpr) + (A.a3/pow(tpr, 3)) + (A.a4/pow(tpr, 4)) + (A.a5/pow(tpr, 5))) * ro) 
      + (((A.a6) + (A.a7/tpr) + (A.a8/pow(tpr, 2))) * (pow(ro, 2))) 
      - ((A.a9) * ((A.a7/tpr) + (A.a8/pow(tpr, 2))) * (pow(ro, 5))) 
      + ((A.a10) * ((1) + (A.a11*pow(ro, 2))) * ((pow(ro, 2)/pow(tpr, 3)) * (pow(e, (-A.a11 * pow(ro, 2)))))));
    }

    return z.roundToDecimalPlaces(3);
  }

}

void main(){
  
  /*print("${(FactorZ().calcular(ppr: 2.99, tpr: 1.38))}");
  print("${(FactorZ().calcular(ppr: 2.45, tpr: 1.38))}");
  print("${(FactorZ().calcular(ppr: 1.5, tpr: 1.38))}");
  print("${(FactorZ().calcular(ppr: 0.75, tpr: 1.38))}");

  print("${(FactorZ().calcular(ppr: (440.88/661.4), tpr: (720.0/474.82)))}");
  print("${(FactorZ().calcular(ppr: 0.62, tpr: 1.44))}");  
  print("${((0.909*0.9302) + (0.091)).roundToDecimalPlaces(3)}");*/

  double p = 3000;
  double t = 640;

  double ppcH = 640.03;
  double tpcH = 370.15;

  double yH = 0.97;

  double ppcHcorrigido = ppcH/0.97;
  double tpcHcorrigido = tpcH/0.97;

  double pprH = (p*sqrt(yH))/ppcHcorrigido;
  double tprH = t/tpcHcorrigido;



  print("Metodo Bateu com DAK:${(FactorZ().calcular(ppr: 4.5, tpr: 1.67))}");
  
  print("pprH: ${pprH.roundToDecimalPlaces(2)}");
  print("tprH: ${tprH.roundToDecimalPlaces(2)}");
  print("${(FactorZ().calcular(ppr: 4.48, tpr: 1.68)).roundToDecimalPlaces(3)}");
  print("Metodo Bateu com Handbook: ${((0.97*FactorZ().calcular(ppr: pprH, tpr: tprH)) + (0.02*0.277) + (0.01*0.289)).roundToDecimalPlaces(2)}");

  print("${(FactorZ().calcular(ppr: 4.48, tpr: 1.64)).roundToDecimalPlaces(3)}");
}

