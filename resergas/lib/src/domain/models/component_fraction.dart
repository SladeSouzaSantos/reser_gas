import 'component.dart';


class ComponentFraction {
  final Component component;
  final double fraction;

  const ComponentFraction({
    required this.component,
    required this.fraction,
  });
  
  ComponentFraction copyWith({
    double? fraction,
    Component? component,
  }) {
    return ComponentFraction(
      component: component ?? this.component,
      fraction: fraction ?? this.fraction,
    );
  }

  // --- CONVERSÃO PARA MAP (JSON) ---
  Map<String, dynamic> toJson() => {
    'component': component.toJson(),
    'fraction': fraction,
  };

  // --- CRIAÇÃO A PARTIR DE MAP (FROM JSON) ---
  factory ComponentFraction.fromJson(Map<String, dynamic> json) {
    return ComponentFraction(
      component: Component.fromJson(json['component'] as Map<String, dynamic>),
      fraction: (json['fraction'] as num).toDouble(), 
    );
  }
}