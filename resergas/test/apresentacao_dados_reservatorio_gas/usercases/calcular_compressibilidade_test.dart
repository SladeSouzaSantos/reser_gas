import 'package:flutter_test/flutter_test.dart';
import 'package:resergas/src/apresentacao_dados_reservatorio_gas/usercases/calcular_compressibilidade.dart';

// cg = (1/(Ppr*Ppc)) + (1/(Z*Ppc)) * ( (3.52 / 10^(0.9813*Tpr)) - (0.548*Ppr / 10^(0.8157*Tpr)) )
void main() {
  group('CalcularCompressibilidade', () {
    const double ppc = 670.0; // psia
    const double ppr = 2.0; // Adimensional
    const double tpr = 1.30; // Adimensional
    const double fatorZ = 0.7711; // Adimensional

    test('Calcula compressibilidade para valores normais e arredonda para 6 casas', () {
      // Resultado calculado: 0.0009226816...
      const double esperado = 0.000923; // Arredondado para 6 casas
      
      final resultado = CalcularCompressibilidade.calcular(
        pressaoPseudoCritica: ppc,
        pressaoPseudoReduzida: ppr,
        temperaturaPseudoReduzida: tpr,
        fatorCompressibilidadeGas: fatorZ,
      );

      expect(resultado, closeTo(esperado, 0.000001));
    });

    test('Lida com fator de compressibilidade Z = 1.0', () {
      // Resultado calculado (Z=1.0): 0.0008821586...
      const double esperado = 0.000882;
      
      final resultado = CalcularCompressibilidade.calcular(
        pressaoPseudoCritica: ppc,
        pressaoPseudoReduzida: ppr,
        temperaturaPseudoReduzida: tpr,
        fatorCompressibilidadeGas: 1.0,
      );

      expect(resultado, closeTo(esperado, 0.000001));
    });

    test('Lida com divisao por zero (Ppc = 0.0)', () {
      final resultado = CalcularCompressibilidade.calcular(
        pressaoPseudoCritica: 0.0,
        pressaoPseudoReduzida: ppr,
        temperaturaPseudoReduzida: tpr,
        fatorCompressibilidadeGas: fatorZ,
      );
      
      expect(resultado == null, isTrue);
    });

    test('Lida com divisao por zero (Ppr = 0.0)', () {
      final resultado = CalcularCompressibilidade.calcular(
        pressaoPseudoCritica: ppc,
        pressaoPseudoReduzida: 0.0,
        temperaturaPseudoReduzida: tpr,
        fatorCompressibilidadeGas: fatorZ,
      );
      
      expect(resultado == null, isTrue);
    });

    test('Lida com divisao por zero (Tpr = 0.0)', () {
      final resultado = CalcularCompressibilidade.calcular(
        pressaoPseudoCritica: ppc,
        pressaoPseudoReduzida: ppr,
        temperaturaPseudoReduzida: 0,
        fatorCompressibilidadeGas: fatorZ,
      );
      
      expect(resultado == null, isTrue);
    });

    test('Lida com divisao por zero (z = 0.0)', () {
      final resultado = CalcularCompressibilidade.calcular(
        pressaoPseudoCritica: ppc,
        pressaoPseudoReduzida: ppr,
        temperaturaPseudoReduzida: tpr,
        fatorCompressibilidadeGas: 0,
      );
      
      expect(resultado == null, isTrue);
    });
  });
}