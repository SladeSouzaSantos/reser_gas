import 'package:flutter_test/flutter_test.dart';
import 'package:resergas/src/apresentacao_dados_reservatorio_gas/usercases/calcular_propriedades_pseudo_reduzidas.dart';

void main() {
  group('CalcularPropriedadesPseudoReduzidas', () {
    const double pressao = 2000.0;
    const double temperatura = 600.0;
    const double ppc = 670.0;
    const double tpc = 370.0;

    // Ppr_base = 2000.0 / 670.0 = 2.98507... -> 2.99
    // Tpr = 600.0 / 370.0 = 1.62162... -> 1.62

    test('Calcula Ppr e Tpr sem a fracao de hidrocarbonetos (Ppr = P/Ppc)', () {
      final (ppr, tpr) = CalcularPropriedadesPseudoReduzidas.calcular(
        pressao: pressao,
        temperatura: temperatura,
        pressaoPseudoCritica: ppc,
        temperaturaPseudoCritica: tpc,
        fracaoHidrocarbonetos: null,
      );

      expect(ppr, closeTo(2.99, 0.01));
      expect(tpr, closeTo(1.62, 0.01));
    });

    test('Calcula Ppr e Tpr com fracao de hidrocarbonetos (0.81) e arredondamento', () {
      const double fracaoHc = 0.81;

      // Ppr_hc = (2000.0 * sqrt(0.81)) / 670.0 = 1800.0 / 670.0 = 2.68656... -> 2.69
      
      final (ppr, tpr) = CalcularPropriedadesPseudoReduzidas.calcular(
        pressao: pressao,
        temperatura: temperatura,
        pressaoPseudoCritica: ppc,
        temperaturaPseudoCritica: tpc,
        fracaoHidrocarbonetos: fracaoHc,
      );

      expect(ppr, closeTo(2.69, 0.01));
      expect(tpr, closeTo(1.62, 0.01));
    });

    test('Lida com fracaoHidrocarbonetos = 0.0 (deve usar Ppr = P/Ppc)', () {
      final (ppr, tpr) = CalcularPropriedadesPseudoReduzidas.calcular(
        pressao: pressao,
        temperatura: temperatura,
        pressaoPseudoCritica: ppc,
        temperaturaPseudoCritica: tpc,
        fracaoHidrocarbonetos: 0.0,
      );

      expect(ppr, closeTo(2.99, 0.01));
      expect(tpr, closeTo(1.62, 0.01));
    });
  });
}