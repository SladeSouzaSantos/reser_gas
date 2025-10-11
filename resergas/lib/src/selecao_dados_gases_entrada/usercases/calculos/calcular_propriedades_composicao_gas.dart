import '../../../domain/models/component_fraction.dart';
import '../../domain/models/gas_component_result.dart';
import '../componentes/percorrer_componentes.dart';

class CalcularPropriedadesComposicaoGas {

  static GasComponentResult? calcular({required List<ComponentFraction> components}){

    if (components.isEmpty) {
      
      return null;
    }
    
    return PercorrerComponentes().pecorrer(components: components);
  }

}