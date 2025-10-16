
import 'package:flutter_test/flutter_test.dart';
import 'package:resergas/src/apresentacao_dados_reservatorio_gas/usercases/calcular_massa_especifica.dart';

void main() {
  group('CalcularMassaEspecifica', () {
    test('Calcula a massa específica para valores normais (P=2000, M=20, Z=0.85, T=600)', () {
      const double pressao = 2000.0; // psia
      const double pesoMolecular = 20.0; // lb/lbmol
      const double fatorZ = 0.85; // Adimensional
      const double temperatura = 600.0; // R

      // Fórmula: ((P * M) / (10.73 * Z * T)) = 7.3094...
      const double esperado = 7.31; // Arredondado para 2 casas
      
      final resultado = CalcularMassaEspecifica.calcular(
        pressao: pressao,
        molecularWeight: pesoMolecular,
        fatorCompressibilidadeGas: fatorZ,
        temperatura: temperatura,
      );

      expect(resultado, closeTo(esperado, 0.01));
    });

    test('Lida com fator Z = 1.0 (P=1000, M=16, Z=1.0, T=520)', () {
      const double pressao = 1000.0;
      const double pesoMolecular = 16.0;
      const double fatorZ = 1.0;
      const double temperatura = 520.0;

      // Esperado: 2.8675...
      const double esperado = 2.87; // Arredondado para 2 casas
      
      final resultado = CalcularMassaEspecifica.calcular(
        pressao: pressao,
        molecularWeight: pesoMolecular,
        fatorCompressibilidadeGas: fatorZ,
        temperatura: temperatura,
      );

      expect(resultado, closeTo(esperado, 0.01));
    });

    test('Retorna 0.0 se a pressão for 0.0', () {
      final resultado = CalcularMassaEspecifica.calcular(
        pressao: 0.0,
        molecularWeight: 20.0,
        fatorCompressibilidadeGas: 0.85,
        temperatura: 600.0,
      );
      expect(resultado, equals(0.0));
    });

    test('Lida com divisão por zero (Temperatura = 0)', () {
      final resultado = CalcularMassaEspecifica.calcular(
        pressao: 1000.0,
        molecularWeight: 16.0,
        fatorCompressibilidadeGas: 1.0,
        temperatura: 0.0,
      );
      expect(resultado == null, isTrue);
    });
  });
}