import 'component.dart';

// Representa um componente de gás selecionado pelo usuário e sua respectiva fração molar.
class ComponentFraction {
  final Component component;
  final double fraction;

  const ComponentFraction({
    required this.component,
    required this.fraction,
  });

  // Método para criar uma nova instância com a fração atualizada (usado para somar frações).
  ComponentFraction copyWith({
    double? fraction,
  }) {
    return ComponentFraction(
      component: component,
      fraction: fraction ?? this.fraction,
    );
  }
}