import '../models/component.dart';

class ComponentsGPSA {
  static Map<String, Component> componentMap = {
    
    'Methane': Component(
      name: "Methane", 
      molecularWeight: 16.043,
      pseudocriticalPressure: 668.0, 
      pseudocriticalTemperature: -116.37, 
      criticalZFactor: 0.288,
    ),
    'Ethane': Component(
      name: "Ethane", 
      molecularWeight: 30.07,
      pseudocriticalPressure: 708.3,
      pseudocriticalTemperature: 90.23, 
      criticalZFactor: 0.285,
    ),
    'Propane': Component(
      name: "Propane",
      molecularWeight: 44.10,
      pseudocriticalPressure: 616.3,
      pseudocriticalTemperature: 206.33, 
      criticalZFactor: 0.276,
    ),
    'nButane': Component(
      name: "nButane",
      molecularWeight: 58.12,
      pseudocriticalPressure: 550.7,
      pseudocriticalTemperature: 305.93, 
      criticalZFactor: 0.274,
    ),
    'iButane': Component(
      name: "iButane",
      molecularWeight: 58.12,
      pseudocriticalPressure: 529.1,
      pseudocriticalTemperature: 275.03, 
      criticalZFactor: 0.282,
    ),
    'nPentane': Component(
      name: "nPentane",
      molecularWeight: 72.15,
      pseudocriticalPressure: 488.6,
      pseudocriticalTemperature: 385.93, 
      criticalZFactor: 0.270,
    ),
    'iPentane': Component(
      name: "iPentane",
      molecularWeight: 72.15,
      pseudocriticalPressure: 490.4,
      pseudocriticalTemperature: 369.33, 
      criticalZFactor: 0.268,
    ),
    'nHexane': Component(
      name: "nHexane",
      molecularWeight: 86.18,
      pseudocriticalPressure: 436.9,
      pseudocriticalTemperature: 453.93, 
      criticalZFactor: 0.264,
    ),
    'nHeptane': Component(
      name: "nHeptane",
      molecularWeight: 100.21,
      pseudocriticalPressure: 396.8,
      pseudocriticalTemperature: 512.63, 
      criticalZFactor: 0.261,
    ),
    'nOctane': Component(
      name: "nOctane",
      molecularWeight: 114.23,
      pseudocriticalPressure: 360.7,
      pseudocriticalTemperature: 564.23, 
      criticalZFactor: 0.257,
    ),
    'nNonane': Component(
      name: "nNonane",
      molecularWeight: 128.26,
      pseudocriticalPressure: 329.4,
      pseudocriticalTemperature: 610.63, 
      criticalZFactor: 0.255,
    ),
    'nDecane': Component(
      name: "nDecane",
      molecularWeight: 142.29,
      pseudocriticalPressure: 303.0,
      pseudocriticalTemperature: 651.33, 
      criticalZFactor: 0.250,
    ),    
    'Hydrogen': Component(
      name: "Hydrogen",
      molecularWeight: 2.016,
      pseudocriticalPressure: 188.0,
      pseudocriticalTemperature: -399.47,
      criticalZFactor: 0.304,
    ),
    'Nitrogen': Component(
      name: "Nitrogen",
      molecularWeight: 28.01,
      pseudocriticalPressure: 493.1,
      pseudocriticalTemperature: -232.47, 
      criticalZFactor: 0.291,
    ),
    'Oxygen': Component(
      name: "Oxygen",
      molecularWeight: 32.0,
      pseudocriticalPressure: 730.0,
      pseudocriticalTemperature: -181.47, 
      criticalZFactor: 0.292,
    ),
    'HydrogenSulfide': Component(
      name: "HydrogenSulfide",
      molecularWeight: 34.08,
      pseudocriticalPressure: 1306.0,
      pseudocriticalTemperature: 212.73, 
      criticalZFactor: 0.284,
    ),
    'CarbonDioxide': Component(
      name: "CarbonDioxide",
      molecularWeight: 44.01,
      pseudocriticalPressure: 1070.6,
      pseudocriticalTemperature: 87.93, 
      criticalZFactor: 0.276,
    ),
  };

}