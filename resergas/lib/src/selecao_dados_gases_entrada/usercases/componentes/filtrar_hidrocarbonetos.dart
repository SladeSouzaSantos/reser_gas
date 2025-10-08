import '../../../domain/data/components.dart';
import '../../../domain/models/component_fraction.dart';
import 'filtro_componentes_contaminantes_or_hidrocarbonetos.dart';

class FiltrarHidrocarbonetos {
  List<ComponentFraction>? filtrar({required List<ComponentFraction> composicaoGas}){
    List<ComponentFraction>? composicaoHidrocarbonetos = FiltroComponentesContaminantesOrHidrocarbonetos().filtrar(composicaoGas: composicaoGas, nonHydrocarbonOrHydrocarbonNames: Components.getHydrocarbonComponentsSet());
    return composicaoHidrocarbonetos;
  }
}