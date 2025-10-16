import 'package:flutter_test/flutter_test.dart';
import 'package:resergas/src/apresentacao_dados_reservatorio_gas/usercases/calcular_compressibilidade_reduzida.dart';

void main() {
  group('CalcularCompressibilidadeReduzida', () {
    const double ppc = 670.0; // psia
    const double cg = 0.0009226816; // psi⁻¹

    // cr = cg * Ppc = 0.0009226816 * 670.0 = 0.618196672
    // Arredondado para 4 casas: 0.6182

    test('Calcula a compressibilidade reduzida para valores normais e arredonda para 4 casas', () {
      const double esperado = 0.6182;
      
      final resultado = CalcularCompressibilidadeReduzida.calcular(
        pressaoPseudoCritica: ppc,
        compressibilidadeGas: cg,
      );

      expect(resultado, closeTo(esperado, 0.0001));
    });

    test('Retorna 0.0 se a compressibilidade do gás for 0.0', () {
      final resultado = CalcularCompressibilidadeReduzida.calcular(
        pressaoPseudoCritica: ppc,
        compressibilidadeGas: 0.0,
      );
      expect(resultado, equals(0.0));
    });

    test('Retorna null se a compressibilidade do gás for null', () {
      final resultado = CalcularCompressibilidadeReduzida.calcular(
        pressaoPseudoCritica: ppc,
        compressibilidadeGas: null,
      );
      expect(resultado, null);
    });
  });
}