import '../../../domain/models/component_fraction.dart';

class FiltroComponentesContaminantesOrHidrocarbonetos {
  List<ComponentFraction>? filtrar({required List<ComponentFraction> composicaoGas, required Set<String> nonHydrocarbonOrHydrocarbonNames}){
    final List<ComponentFraction> hidrocarbonetosOrNonHCFractions = composicaoGas.where((fraction) {
      return nonHydrocarbonOrHydrocarbonNames.contains(fraction.component.name);
    }).toList();

    return hidrocarbonetosOrNonHCFractions;
  }
}