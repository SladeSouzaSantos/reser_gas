import 'package:flutter_test/flutter_test.dart';
import 'package:resergas/src/apresentacao_dados_reservatorio_gas/usercases/calcular_propriedades_pseudo_critica_por_densidade.dart';
// Import 'dart:math' é necessário para as funções de cálculo

void main() {
  group('CalcularPropriedadesPseudoCriticaPorDensidade', () {

    // --- Caso 1: Gás Seco, Sem Contaminantes ---
    test('Calcula para Gás Seco sem contaminantes (dg=0.65)', () {
      const String gasTipo = "Seco";
      const double dg = 0.65;
      
      // PPC Esperado (Seco): 677 + (15 * 0.65) - (37.5 * 0.65^2) = 670.90625 -> 670.91
      // TPC Esperado (Seco): 168 + (325 * 0.65) - (12.5 * 0.65^2) = 373.96875 -> 373.97

      final (ppc, tpc) = CalcularPropriedadesPseudoCriticaPorDensidade.calcular(
        gasTipo: gasTipo,
        dg: dg,
        yCO2: 0.0,
        yH2S: 0.0,
        yN2: 0.0,
      );

      expect(ppc, closeTo(670.91, 0.01));
      expect(tpc, closeTo(373.97, 0.01));
    });

    // --- Caso 2: Gás Úmido, Sem Contaminantes ---
    test('Calcula para Gás Úmido sem contaminantes (dg=0.85)', () {
      const String gasTipo = "Úmido";
      const double dg = 0.85;

      // PPC Esperado (Úmido): 706 + (51.7 * 0.85) - (11.1 * 0.85^2) = 741.9275 -> 741.93
      // TPC Esperado (Úmido): 187 + (330 * 0.85) - (71.5 * 0.85^2) = 415.79625 -> 415.84

      final (ppc, tpc) = CalcularPropriedadesPseudoCriticaPorDensidade.calcular(
        gasTipo: gasTipo,
        dg: dg,
        yCO2: 0.0,
        yH2S: 0.0,
        yN2: 0.0,
      );

      expect(ppc, closeTo(741.93, 0.01));
      expect(tpc, closeTo(415.84, 0.01));
    });

    // --- Caso 3: Gás Seco, Com Contaminantes (Correção Completa) ---
    test('Calcula com contaminantes (N2=0.03, CO2=0.05, H2S=0.02) e aplica correção', () {
      const String gasTipo = "Seco";
      const double dgOriginal = 0.80;
      const double yCO2 = 0.05;
      const double yH2S = 0.02;
      const double yN2 = 0.03;
      
      const double ppcEsperado = 675.77;
      const double tpcEsperado = 399.41;

      final (ppc, tpc) = CalcularPropriedadesPseudoCriticaPorDensidade.calcular(
        gasTipo: gasTipo,
        dg: dgOriginal,
        yCO2: yCO2,
        yH2S: yH2S,
        yN2: yN2,
      );

      expect(ppc, closeTo(ppcEsperado, 0.01));
      expect(tpc, closeTo(tpcEsperado, 0.01));
    });
  });
}