import 'package:flutter_test/flutter_test.dart';
import 'package:resergas/src/apresentacao_dados_reservatorio_gas/usercases/calcular_factor_z.dart';

// Nota: O teste usa valores conhecidos da correlação Dranchuk e Abou-Kassem (DAK).
void main() {
  group('CalcularFactorZ (Dranchuk e Abou-Kassem)', () {

    test('Calcula o Fator Z para Ppr=2.5 e Tpr=2.0 (Exemplo de Referência)', () {
      const double ppr = 2.5;
      const double tpr = 2;
      const double esperado = 0.9400752;

      //Valor de Refência: https://f0nzie.github.io/zFactor/?utm_source=chatgpt.com
      
      final resultado = CalcularFactorZ.calcular(ppr: ppr, tpr: tpr);
      
      expect(resultado, closeTo(esperado, 0.0001));
    });

    test('Calcula o Fator Z para Ppr=2.0 e Tpr=3.0 (Próximo de 1.0)', () {
      const double ppr = 2.0;
      const double tpr = 3.0;
      
      const double esperado = 1.0021;
      
      final resultado = CalcularFactorZ.calcular(ppr: ppr, tpr: tpr);

      expect(resultado, closeTo(esperado, 0.0001));
    });

    test('Calcula o Fator Z para condições de baixa pressão (z ≈ 1.0)', () {
      const double ppr = 0.2;
      const double tpr = 1.0;
      
      const double esperado = 0.925439;
      
      final resultado = CalcularFactorZ.calcular(ppr: ppr, tpr: tpr);

      expect(resultado, closeTo(esperado, 0.0001));
    });
  });
}