# 🛢️ ReserGas: Gas Properties Calculator (Flutter/Dart)

ReserGas é um aplicativo mobile desenvolvido em Flutter/Dart para o cálculo rápido e preciso de diversas propriedades do Gás de Reservatório (Gás Natural), utilizando correlações consagradas da Engenharia de Reservatórios.

# 🎯 Objetivo Principal
O objetivo principal do projeto é estimar as propriedades do gás presentes em um reservatório (como Fator de Compressibilidade, Viscosidade, Fator Volume-Formação, etc.) com precisão. Para isso, todo o foco de desenvolvimento foi na confiabilidade numérica e no isolamento da lógica de negócio.

# ⚙️ Arquitetura e Estrutura
O projeto adota uma arquitetura inspirada em Clean Architecture e Domain-Driven Design (DDD), garantindo a separação de responsabilidades, testabilidade e manutenibilidade:
Domain: Contém as entidades, modelos (GasReservatorio, Component, etc.) e contratos.
UserCases: Camada que executa a lógica de negócio crucial (os cálculos e correlações da engenharia). Esta é a camada mais testada.
Presentation: Camada Flutter (Widgets, Telas) responsável pela interface e consumo dos UserCases.

# 🧪 Testes Unitários: Garantia da Precisão Numérica (Core Business)
A precisão dos algoritmos de engenharia é o ponto mais crítico do projeto. A camada de UserCases é 100% isolada e coberta por testes unitários focados na validação da exatidão numérica das correlações e no tratamento de erros (Edge Cases).

Exemplo de Teste Unitário (Foco em Edge Cases):
O teste para CalcularPropriedadesPseudoCriticaPorComposicao demonstra a preocupação em validar tanto o resultado esperado quanto o tratamento de cenários de erro (como divisão por zero, crucial para a robustez).

    group('CalcularPropriedadesPseudoCriticaPorComposicao', () {
      
      test('Lida com fracaoHidrocarboneto = 0.0 (Lançamento de ArgumentError)', () {
        expect(
          () => CalcularPropriedadesPseudoCriticaPorComposicao.calcular(
            pressaoPseudoCriticaHidrocarboneto: 100.0,
            temperaturaPseudoCriticaHidrocarboneto: 200.0,
            fracaoHidrocarboneto: 0.0, // Causa de erro (divisão por zero)
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
      
      test('Calcula propriedades corretamente para fracao > 0.0', () {
        const double ppcHc = 100.0;
        const double tpcHc = 200.0;
        const double fracaoHc = 0.5;
        
        final (ppc, tpc) = CalcularPropriedadesPseudoCriticaPorComposicao.calcular(
          pressaoPseudoCriticaHidrocarboneto: ppcHc,
          temperaturaPseudoCriticaHidrocarboneto: tpcHc,
          fracaoHidrocarboneto: fracaoHc,
        );
    
        expect(ppc, 200.00); // Esperado: 100.0 / 0.5 = 200.0
        expect(tpc, 400.00); // Esperado: 200.0 / 0.5 = 400.0
      });
    });

# ✨ Funcionalidades e Correlações Implementadas
O aplicativo permite a entrada de dados por 3 métodos (Composição, Densidade ou Massa Molecular) e calcula as seguintes propriedades:
Fator de Compressibilidade (Dranchuk e Abou-Kassem);
Viscosidade (Lee, Gonzalez & Eakin + Correção de Carr);
Compressibilidade (Correlação de Mattar);
Propriedades Pseudo-Críticas (Kay's Rule (Composição) / Correlação de Sutton (Densidade));
Massa Específica, Fator Volume-Formação e Propriedades Pseudo-Reduzidas (Equação do Gás Real).

# 🖼️ Screenshots

<img width="270" height="600" alt="image" src="https://github.com/user-attachments/assets/39267291-65f8-4ab1-9c54-066f3ee1c1c1" />
<img width="270" height="600" alt="image" src="https://github.com/user-attachments/assets/40cfd6cf-6cf8-43eb-a853-12cbf0369b78" />
<img width="270" height="600" alt="image" src="https://github.com/user-attachments/assets/25630f92-ab65-4320-bdcc-ec3bdc0e6dd3" />
<img width="270" height="600" alt="image" src="https://github.com/user-attachments/assets/ebdec0a0-5257-4dd2-b4b9-9c0022697b36" />








