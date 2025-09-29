import 'package:flutter/material.dart';

import '../widgets/entrada_densidade_widget.dart';
import '../widgets/entrada_massa_molecular_widget.dart';
import '../widgets/entrada_propriedades_widget.dart';
import '../usercases/entrada_gases_controller.dart'; 

class TelaEntradaGases extends StatefulWidget {
  final String idiomaSelecionado;
  const TelaEntradaGases({
    super.key,
    required this.idiomaSelecionado,
  });

  @override
  State<TelaEntradaGases> createState() => _TelaEntradaGasesState();
}

class _TelaEntradaGasesState extends State<TelaEntradaGases> with SingleTickerProviderStateMixin {
  
  late final EntradaGasesController _controller;
  late final TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    
    _controller = EntradaGasesController(idiomaInicial: widget.idiomaSelecionado);
    _controller.addListener(_onControllerChange);
    
    _tabController = TabController(length: 3, vsync: this);
  }
  
  void _onControllerChange() {
    setState(() {});
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    super.dispose();
  }
  
  String _getTranslation(String key) => _controller.getTranslation(key);

  Widget _buildConfirmButton(VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),

        ),
        child: Text(_getTranslation('botao_confirmar')),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131518),
      appBar: AppBar(
        title: Text(
          _getTranslation('titulo'),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F2228),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white54,
          tabs: <Widget>[
            Tab(text: _getTranslation('aba_densidade')),
            Tab(text: _getTranslation('aba_massa')),
            Tab(text: _getTranslation('aba_propriedades')),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            
            EntradaDensidadeWidget(
              getTranslation: _getTranslation,
              selectedDensityType: _controller.selectedDensityType,
              onDensityChange: _controller.handleDensityChange,
              densityController: _controller.densityController,
              onConfirm: _controller.onConfirmDensidade,
              buildConfirmButton: _buildConfirmButton,
            ),
            
            
            EntradaMassaMolecularWidget(
              getTranslation: _getTranslation,
              massaMolecularController: _controller.massaMolecularController,
              onConfirm: _controller.onConfirmMassaMolecular,
              buildConfirmButton: _buildConfirmButton,
            ),
            

            EntradaPropriedadesWidget(
              getTranslation: _getTranslation,              
              currentLanguage: _controller.currentLanguage,
              selectedComponents: _controller.selectedComponents,
              selectedComponentToAdd: _controller.selectedComponentToAdd,
              onComponentSelect: _controller.handleComponentSelect,
              fractionController: _controller.fractionController,
              onAddComponentFraction: () => _controller.addComponentFraction(context),
              onRemoveComponent: (item) => _controller.removeComponent(context, item),
              totalFraction: _controller.totalFraction,
              onConfirm: () => _controller.onConfirmPropriedades(context),
              buildConfirmButton: _buildConfirmButton,
            ),
          ],
        ),
      ),
    );
  }
}