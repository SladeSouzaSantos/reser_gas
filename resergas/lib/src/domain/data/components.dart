import '../models/component.dart';

class Components {
  
  static const Map<String, Component> _componentMap = {
    // Hidrocarbonetos
    'Methane': Component(
      name: "Methane", 
      molecularWeight: 16.042,
      pseudocriticalPressure: 673.10,
      pseudocriticalTemperature: -116.5,
    ),
    'Ethane': Component(
      name: "Ethane", 
      molecularWeight: 30.068,
      pseudocriticalPressure: 708.3,
      pseudocriticalTemperature: 90.09,
    ),
    'Propane': Component(
      name: "Propane",
      molecularWeight: 44.094,
      pseudocriticalPressure: 617.4,
      pseudocriticalTemperature: 206.26,
    ),
    'nButane': Component(
      name: "nButane",
      molecularWeight: 58.120,
      pseudocriticalPressure: 550.7,
      pseudocriticalTemperature: 305.62,
    ),
    'iButane': Component(
      name: "iButane",
      molecularWeight: 58.120,
      pseudocriticalPressure: 529.1,
      pseudocriticalTemperature: 274.96,
    ),
    'nPentane': Component(
      name: "nPentane",
      molecularWeight: 72.146,
      pseudocriticalPressure: 489.5,
      pseudocriticalTemperature: 385.92,
    ),
    'iPentane': Component(
      name: "iPentane",
      molecularWeight: 72.146,
      pseudocriticalPressure: 483.0,
      pseudocriticalTemperature: 370.0,
    ),
    'nHexane': Component(
      name: "nHexane",
      molecularWeight: 86.172,
      pseudocriticalPressure: 439.7,
      pseudocriticalTemperature: 454.50,
    ),
    'nHeptane': Component(
      name: "nHeptane",
      molecularWeight: 100.198,
      pseudocriticalPressure: 396.9,
      pseudocriticalTemperature: 512.62,
    ),
    'nOctane': Component(
      name: "nOctane",
      molecularWeight: 114.224,
      pseudocriticalPressure: 362.1,
      pseudocriticalTemperature: 565.2,
    ),
    'nNonane': Component(
      name: "nNonane",
      molecularWeight: 128.250,
      pseudocriticalPressure: 345.0,
      pseudocriticalTemperature: 613.0,
    ),
    'nDecane': Component(
      name: "nDecane",
      molecularWeight: 142.276,
      pseudocriticalPressure: 320.0,
      pseudocriticalTemperature: 655.0,
    ),

    // Não-Hidrocarbonetos
    'Hydrogen': Component(
      name: "Hydrogen",
      molecularWeight: 2.016,
      pseudocriticalPressure: 188.0,
      pseudocriticalTemperature: -399.8,
    ),
    'Nitrogen': Component(
      name: "Nitrogen",
      molecularWeight: 28.016,
      pseudocriticalPressure: 492.0,
      pseudocriticalTemperature: -232.8,
    ),
    'Oxygen': Component(
      name: "Oxygen",
      molecularWeight: 32.0,
      pseudocriticalPressure: 730.0,
      pseudocriticalTemperature: -181.8,
    ),
    'HydrogenSulfide': Component(
      name: "HydrogenSulfide",
      molecularWeight: 34.076,
      pseudocriticalPressure: 1306.0,
      pseudocriticalTemperature: 212.7,
    ),
    'CarbonDioxide': Component(
      name: "CarbonDioxide",
      molecularWeight: 44.010,
      pseudocriticalPressure: 1073.0,
      pseudocriticalTemperature: 88.0,
    ),
    'WaterVapor': Component(
      name: "WaterVapor",
      molecularWeight: 18.015,
      pseudocriticalPressure: 3200.0,
      pseudocriticalTemperature: 705.4,
    ),
    'Helium': Component(
      name: "Helium",
      molecularWeight: 4.002,
      pseudocriticalPressure: 33.2,
      pseudocriticalTemperature: -450.4,
    ),
    'Argon': Component(
      name: "Argon",
      molecularWeight: 39.948,
      pseudocriticalPressure: 705.5,
      pseudocriticalTemperature: -188.4,
    ),
  };

  static const List<String> _nonHydrocarbonKeys = [
    'Nitrogen',
    'Oxygen',
    'HydrogenSulfide',
    'CarbonDioxide',
    'WaterVapor',
    'Helium',
    'Argon',
  ];

  static List<Component> getNonHydrocarbonComponents() {
    return _nonHydrocarbonKeys
        .map((key) => _componentMap[key]!)
        .toList();
  }
  
  static List<String> get nonHydrocarbonKeys => _nonHydrocarbonKeys;

  static List<Component> getAllComponents() => _componentMap.values.toList();
  
  static List<String> get allKeys => _componentMap.keys.toList();
  
  static Component getComponentByKey(String key) {
        return _componentMap[key] ?? _componentMap['Methane']!;
  }
}