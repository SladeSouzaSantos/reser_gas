import '../models/component.dart';
import 'components_adalberto_rosa.dart';

class Components {
  
  static final Map<String, Component> _componentMap = ComponentsAdalbertoRosa.componentMap;
  
  static List<Component> getAllComponents() => _componentMap.values.toList();
  
  static  List<String> get allKeys => _componentMap.keys.toList();

  static const List<String> _hydrocarbonKeys = [
  'Methane',
  'Ethane',
  'Propane',
  'nButane',
  'iButane',
  'nPentane',
  'iPentane',
  'nHexane',
  'nHeptane',
  'nOctane',
  'nNonane',
  'nDecane',
];

  static const List<String> _contaminantesHydrocarbonKeys = [
      'Nitrogen',
      'HydrogenSulfide',
      'CarbonDioxide',
    ];

  static List<String> get hydrocarbonKeys => _hydrocarbonKeys.toList();

  static List<String> get nonHydrocarbonKeys => _contaminantesHydrocarbonKeys.toList();

  static Set<String> getHydrocarbonComponentsSet() => _hydrocarbonKeys.toSet();

  static Set<String> getNonHydrocarbonComponentsSet() => _contaminantesHydrocarbonKeys.toSet();

  static List<Component> getHydrocarbonComponents() => _hydrocarbonKeys.map((key) => _componentMap[key]!).toList();

  static List<Component> getNonHydrocarbonComponents() => _contaminantesHydrocarbonKeys.map((key) => _componentMap[key]!).toList();

  static Component getComponentByKey(String key) {
    return _componentMap[key] ?? _componentMap['Methane']!;
  }
}