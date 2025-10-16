import 'package:flutter_test/flutter_test.dart';
import 'package:resergas/src/apresentacao_dados_reservatorio_gas/usercases/calcular_fator_volume_formacao.dart';

// Bg = (14.7 / 519.67) * ((Z * T) / P)
void main() {
  group('CalcularFatorVolumeFormacao', () {
    const double pressao = 2000.0; // psia
    const double temperatura = 600.0; // R
    const double fatorZ = 0.85; // Adimensional

    const double esperado = 0.0072132; // Arredondado para 6 casas

    test('Calcula o fator volume formação para valores normais e arredonda para 6 casas', () {
      final resultado = CalcularFatorVolumeFormacao.calcular(
        pressao: pressao,
        temperatura: temperatura,
        fatorCompressibilidadeGas: fatorZ,
      );

      expect(resultado, closeTo(esperado, 0.000001));
    });

    test('Lida com fator Z = 1.0', () {
      
      const double esperado = 0.008486;
      
      final resultado = CalcularFatorVolumeFormacao.calcular(
        pressao: pressao,
        temperatura: temperatura,
        fatorCompressibilidadeGas: 1.0,
      );

      expect(resultado, closeTo(esperado, 0.000001));
    });

    test('Lida com divisao por zero (Pressão = 0.0)', () {
      final resultado = CalcularFatorVolumeFormacao.calcular(
        pressao: 0.0,
        temperatura: temperatura,
        fatorCompressibilidadeGas: fatorZ,
      );
      
      expect(resultado == null, isTrue);
    });

    test('Retorna 0.0 se a temperatura for 0.0', () {
      final resultado = CalcularFatorVolumeFormacao.calcular(
        pressao: pressao,
        temperatura: 0.0,
        fatorCompressibilidadeGas: fatorZ,
      );
      expect(resultado, equals(0.0));
    });
  });
}