import '../models/component.dart';

class Components {

  static const Methane = Component(
    name: "Metano (CH₄)",
    molecularWeight: 16.042,
    pseudocriticalPressure: 673.10,
    pseudocriticalTemperature: -116.5,
  );

  static const Ethane = Component(
    name: "Etano (C₂H₆)",
    molecularWeight: 30.068,
    pseudocriticalPressure: 708.3,
    pseudocriticalTemperature: 90.09,
  );

  static const Propane = Component(
    name: "Propano (C₃H₈)",
    molecularWeight: 44.094,
    pseudocriticalPressure: 617.4,
    pseudocriticalTemperature: 206.26,
  );

  static const nButane = Component(
    name: "n-Butano (n-C₄H₁₀)",
    molecularWeight: 58.120,
    pseudocriticalPressure: 550.7,
    pseudocriticalTemperature: 305.62,
  );

  static const iButane = Component(
    name: "i-Butano (i-C₄H₁₀)",
    molecularWeight: 58.120,
    pseudocriticalPressure: 529.1,
    pseudocriticalTemperature: 274.96,
  );

  static const nPentane = Component(
    name: "n-Pentano (n-C₅H₁₂)",
    molecularWeight: 72.146,
    pseudocriticalPressure: 489.5,
    pseudocriticalTemperature: 385.92,
  );

  static const iPentane = Component(
    name: "i-Pentano (i-C₅H₁₂)",
    molecularWeight: 72.146,
    pseudocriticalPressure: 483.0,
    pseudocriticalTemperature: 370.0,
  );

  static const nHexane = Component(
    name: "n-Hexano (n-C₆H₁₄)",
    molecularWeight: 86.172,
    pseudocriticalPressure: 439.7,
    pseudocriticalTemperature: 454.50,
  );

  static const nHeptane = Component(
    name: "n-Heptano (n-C₇H₁₆)",
    molecularWeight: 100.198,
    pseudocriticalPressure: 396.9,
    pseudocriticalTemperature: 512.62,
  );

  static const nOctane = Component(
    name: "n-Octano (n-C₈H₁₈)",
    molecularWeight: 114.224,
    pseudocriticalPressure: 362.1,
    pseudocriticalTemperature: 565.2,
  );

  static const nNonane = Component(
    name: "n-Nonano (n-C₉H₂₀)",
    molecularWeight: 128.250,
    pseudocriticalPressure: 345.0,
    pseudocriticalTemperature: 613.0,
  );

  static const nDecane = Component(
    name: "n-Decano (n-C₁₀H₂₂)",
    molecularWeight: 142.276,
    pseudocriticalPressure: 320.0,
    pseudocriticalTemperature: 655.0,
  );

  static const Hydrogen = Component(
    name: "Hidrogênio (H₂)",
    molecularWeight: 2.016,
    pseudocriticalPressure: 188.0,
    pseudocriticalTemperature: -399.8,
  );

  static const Nitrogen = Component(
    name: "Nitrogênio (N₂)",
    molecularWeight: 28.016,
    pseudocriticalPressure: 492.0,
    pseudocriticalTemperature: -232.8,
  );

  static const Oxygen = Component(
    name: "Oxigênio (O₂)",
    molecularWeight: 32.0,
    pseudocriticalPressure: 730.0,
    pseudocriticalTemperature: -181.8,
  );

  static const HydrogenSulfide = Component(
    name: "Sulfeto de Hidrogênio (H₂S)",
    molecularWeight: 34.076,
    pseudocriticalPressure: 1306.0,
    pseudocriticalTemperature: 212.7,
  );

  static const CarbonDioxide = Component(
    name: "Dióxido de Carbono (CO₂)",
    molecularWeight: 44.010,
    pseudocriticalPressure: 1073.0,
    pseudocriticalTemperature: 88.0,
  );

  // Lista de todos os componentes, útil para Dropdowns ou tabelas de exibição
  static final List<Component> allComponents = [
    Methane, Ethane, Propane, nButane, iButane, nPentane, iPentane, nHexane,
    nHeptane, nOctane, nNonane, nDecane, Hydrogen, Nitrogen, Oxygen, 
    HydrogenSulfide, CarbonDioxide,];
}