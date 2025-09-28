// Define a classe que armazena as propriedades físicas de um componente de gás.
class Component {
  final String name;
  final double molecularWeight;
  final double pseudocriticalPressure;
  final double pseudocriticalTemperature; 

  const Component({
    required this.name,
    required this.molecularWeight,
    required this.pseudocriticalPressure,
    required this.pseudocriticalTemperature,
  });
}