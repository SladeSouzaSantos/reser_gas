import 'package:flutter_test/flutter_test.dart';
import 'package:resergas/src/apresentacao_dados_reservatorio_gas/usercases/calcular_propriedades_pseudo_critica_por_composicao.dart';

void main() {
  group('CalcularPropriedadesPseudoCriticaPorComposicao', () {
    test('Calcula PPC e TPC para fracao normal e arredonda para 2 casas', () {
      const double ppcHc = 1000.0;
      const double tpcHc = 600.0;
      const double fracaoHc = 0.8;

      // PPC Esperado: 1000.0 / 0.8 = 1250.00
      // TPC Esperado: 600.0 / 0.8 = 750.00
      
      final (ppc, tpc) = CalcularPropriedadesPseudoCriticaPorComposicao.calcular(
        pressaoPseudoCriticaHidrocarboneto: ppcHc,
        temperaturaPseudoCriticaHidrocarboneto: tpcHc,
        fracaoHidrocarboneto: fracaoHc,
      );

      expect(ppc, equals(1250.00));
      expect(tpc, equals(750.00));
    });

    test('Lida com arredondamento da PPC (500.0 / 0.3 = 1666.666...)', () {
      const double ppcHc = 500.0;
      const double tpcHc = 100.0;
      const double fracaoHc = 0.3;

      // PPC Esperado: 1666.67
      // TPC Esperado: 333.33
      
      final (ppc, tpc) = CalcularPropriedadesPseudoCriticaPorComposicao.calcular(
        pressaoPseudoCriticaHidrocarboneto: ppcHc,
        temperaturaPseudoCriticaHidrocarboneto: tpcHc,
        fracaoHidrocarboneto: fracaoHc,
      );

      expect(ppc, closeTo(1666.67, 0.001));
      expect(tpc, closeTo(333.33, 0.001));
    });
    
    test('Lida com fracaoHidrocarboneto = 0.0 (Divisão por zero)', () {
      const double ppcHc = 1000.0;
      const double tpcHc = 600.0;
      const double fracaoHc = 0.0;
      
      expect(() => CalcularPropriedadesPseudoCriticaPorComposicao.calcular(
        pressaoPseudoCriticaHidrocarboneto: ppcHc,
        temperaturaPseudoCriticaHidrocarboneto: tpcHc,
        fracaoHidrocarboneto: fracaoHc,
      ), throwsA(isA<ArgumentError>()));
      
    });
  });
}