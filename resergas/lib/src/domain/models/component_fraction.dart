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
  }) {
    return ComponentFraction(
      component: component,
      fraction: fraction ?? this.fraction,
    );
  }
}