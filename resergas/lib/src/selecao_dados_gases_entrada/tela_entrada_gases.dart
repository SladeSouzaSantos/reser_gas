import 'package:flutter/material.dart';
// Importações ajustadas para os modelos e dados do Domínio

// Nota: Estes imports são placeholders, assumindo que existem nos arquivos do seu projeto.
import '../domain/data/components.dart'; 
import '../domain/models/component.dart';
import '../domain/models/component_fraction.dart';

class TelaEntradaGases extends StatefulWidget {
  final String idiomaSelecionado;
  const TelaEntradaGases({super.key, required this.idiomaSelecionado});

  @override
  State<TelaEntradaGases> createState() => _TelaEntradaGasesState();
}

class _TelaEntradaGasesState extends State<TelaEntradaGases> {
  // Estado para o tipo de densidade (Seca/Úmida)
  String _selectedDensityType = 'Seca';

  // Lista dos componentes e suas frações molares adicionados pelo usuário.
  List<ComponentFraction> _selectedComponents = [];

  // O componente atualmente selecionado no Dropdown (inicia com o Metano).
  Component _selectedComponentToAdd = Components.Methane; 

  // Controllers
  final TextEditingController _densityController = TextEditingController();
  final TextEditingController _massaMolecularController = TextEditingController();
  final TextEditingController _fractionController = TextEditingController();

  // Maps de Tradução
  static const Map<String, Map<String, String>> _translations = {
    'Português': {
      'titulo': 'ENTRADA DE PROPRIEDADES DO GÁS',
      'aba_densidade': 'DENSIDADE',
      'aba_massa': 'MASSA MOLECULAR',
      'aba_propriedades': 'PROPRIEDADES (Tabela)',
      'densidade_seco': 'Gás Seco',
      'densidade_umido': 'Gás Úmido',
      'label_densidade': 'Valor da Densidade ({0}) (Ex: 0.8)',
      'label_massa_molecular': 'Massa Molecular (sem unidade)',
      'dropdown_selecione': 'Selecione o Componente',
      'label_fracao': 'Fração Molar (Ex: 0.15)',
      'botao_adicionar': 'Adicionar',
      'botao_confirmar': 'CONFIRMAR',
      'cabecalho_componente': 'Componente',
      'cabecalho_fracao': 'Fração',
      'cabecalho_massa_molecular': 'Ma',
      'cabecalho_pc': 'Psc',
      'cabecalho_tc': 'Tsc',
      'total_somatoria': 'Somatória Total:',
      'erro_zero': 'O valor deve ser maior que 0.',
      'erro_tabela_zero': 'A somatória das frações deve ser maior que 0.',
      'sucesso_confirmar': 'Dados confirmados com sucesso!',
      'erro_fracao_invalida': 'Por favor, insira uma fração decimal válida (> 0).',
      'erro_max_fracao_atingido': 'A soma total não pode exceder 1.0. Capacidade restante: {0}.',
      'erro_soma_maior_um': 'Erro: A soma total excedeu 1.0.',
      'componente_adicionado': 'Componente adicionado/atualizado com sucesso.',
      'componente_removido': 'Componente removido.',
    },
    'Inglês': {
      'titulo': 'GAS PROPERTIES INPUT',
      'aba_densidade': 'DENSITY',
      'aba_massa': 'MOLECULAR WEIGHT',
      'aba_propriedades': 'PROPERTIES (Table)',
      'densidade_seco': 'Dry Gas',
      'densidade_umido': 'Wet Gas',
      'label_densidade': 'Density Value ({0}) (Ex: 0.8)',
      'label_massa_molecular': 'Molecular Weight (no unit)',
      'dropdown_selecione': 'Select Component',
      'label_fracao': 'Mole Fraction (Ex: 0.15)',
      'botao_adicionar': 'Add',
      'botao_confirmar': 'CONFIRM',
      'cabecalho_componente': 'Component',
      'cabecalho_fracao': 'Fraction',
      'cabecalho_massa_molecular': 'Ma',
      'cabecalho_pc': 'Psc',
      'cabecalho_tc': 'Tsc',
      'total_somatoria': 'Total Sum:',
      'erro_zero': 'The value must be greater than 0.',
      'erro_tabela_zero': 'The sum of fractions must be greater than 0.',
      'sucesso_confirmar': 'Data successfully confirmed!',
      'erro_fracao_invalida': 'Please enter a valid decimal fraction (> 0).',
      'erro_max_fracao_atingido': 'Total sum cannot exceed 1.0. Remaining capacity: {0}.',
      'erro_soma_maior_um': 'Error: Total sum exceeded 1.0.',
      'componente_adicionado': 'Component successfully added/updated.',
      'componente_removido': 'Component removed.',
    },
    'Espanhol': {
      'titulo': 'ENTRADA DE PROPIEDADES DEL GAS',
      'aba_densidade': 'DENSIDAD',
      'aba_massa': 'MASA MOLECULAR',
      'aba_propriedades': 'PROPIEDADES (Tabla)',
      'densidade_seco': 'Gas Seco',
      'densidade_umido': 'Gas Húmedo',
      'label_densidade': 'Valor de Densidad ({0}) (Ej: 0.8)',
      'label_massa_molecular': 'Masa Molecular (sin unidad)',
      'dropdown_selecione': 'Selecciona el Componente',
      'label_fracao': 'Fracción Molar (Ej: 0.15)',
      'botao_adicionar': 'Añadir',
      'botao_confirmar': 'CONFIRMAR',
      'cabecalho_componente': 'Componente',
      'cabecalho_fracao': 'Fracción',
      'cabecalho_massa_molecular': 'Ma',
      'cabecalho_pc': 'Psc',
      'cabecalho_tc': 'Tsc',
      'total_somatoria': 'Suma Total:',
      'erro_zero': 'El valor debe ser mayor que 0.',
      'erro_tabela_zero': 'La suma de fracciones debe ser mayor que 0.',
      'sucesso_confirmar': 'Datos confirmados con éxito!',
      'erro_fracao_invalida': 'Por favor, introduce una fracción decimal válida (> 0).',
      'erro_max_fracao_atingido': 'La suma total no puede exceder 1.0. Capacidad restante: {0}.',
      'erro_soma_maior_um': 'Error: La suma total superó 1.0.',
      'componente_adicionado': 'Componente añadido/actualizado con éxito.',
      'componente_removido': 'Componente eliminado.',
    },
  };

  @override
  void initState() {
    super.initState();
    // Garante que o primeiro componente da lista seja o selecionado inicialmente
    _selectedComponentToAdd = Components.allComponents.first;
  }

  @override
  void dispose() {
    _densityController.dispose();
    _massaMolecularController.dispose();
    _fractionController.dispose();
    super.dispose();
  }

  // --- Funções Auxiliares de Tradução e UI ---

  String _getTranslation(String key) {
    // Busca a tradução. Se não encontrar no idioma selecionado, usa Português como fallback.
    return _translations[widget.idiomaSelecionado]?[key] ?? _translations['Português']![key] ?? key;
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(milliseconds: 2500),
      ),
    );
  }

  // MODIFICAÇÃO: Envolve o botão em um Center para garantir o alinhamento central
  Widget _buildConfirmButton(VoidCallback onPressed) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(_getTranslation('botao_confirmar'), style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // Propriedade computada para calcular a somatória total das frações
  double get _totalFraction => _selectedComponents.fold(0.0, (sum, item) => sum + item.fraction);


  // --- Lógica de Confirmação por Aba ---

  // Validação para Densidade e Massa Molecular
  void _onConfirmSimpleValue(TextEditingController controller) {
    final value = double.tryParse(controller.text.replaceAll(',', '.'));
    if (value == null || value <= 0) {
      _showSnackBar(_getTranslation('erro_zero'), Colors.red);
      return;
    }
    _showSnackBar(_getTranslation('sucesso_confirmar'), Colors.green);
    // Aqui você enviaria o valor para o próximo passo.
    print('Valor confirmado: $value');
  }

  void _onConfirmDensidade() {
    _onConfirmSimpleValue(_densityController);
  }

  void _onConfirmMassaMolecular() {
    _onConfirmSimpleValue(_massaMolecularController);
  }

  void _onConfirmPropriedades() {
    final total = _totalFraction;

    // Verificação se a soma total é maior que zero
    if (total <= 0) {
      _showSnackBar(_getTranslation('erro_tabela_zero'), Colors.red);
      return;
    }

    // Verificação de limite máximo (embora a lógica de adição já limite, é bom ter aqui)
    if (total > 1.0 + 1e-6) { // Usando tolerância para float
      _showSnackBar(_getTranslation('erro_soma_maior_um'), Colors.red);
      return;
    }

    _showSnackBar(_getTranslation('sucesso_confirmar'), Colors.green);
    // Aqui você enviaria os dados de _selectedComponents para o próximo passo.
    print('Dados de Propriedades Confirmados: $_selectedComponents');
  }


  // --- Lógica de Adição e Validação de Fração Molar ---

  void _addComponentFraction() {
    final fractionText = _fractionController.text.replaceAll(',', '.');
    final newFraction = double.tryParse(fractionText);

    if (newFraction == null || newFraction <= 0) {
      _showSnackBar(_getTranslation('erro_fracao_invalida'), Colors.red);
      return;
    }

    // Encontra o componente existente, se houver
    final existingIndex = _selectedComponents.indexWhere(
      (item) => item.component.name == _selectedComponentToAdd.name,
    );

    final currentTotal = _totalFraction;

    // Calcula a fração que PRECISAMOS verificar para o limite de 1.0.
    double fractionAfterAddition;
    if (existingIndex != -1) {
      // Se o componente existe, a nova fração é a soma:
      // Total Atual - Fração Antiga do Componente + Nova Fração
      fractionAfterAddition = currentTotal - _selectedComponents[existingIndex].fraction + newFraction;
    } else {
      // Se for novo, a nova fração é a soma atual mais o novo componente:
      fractionAfterAddition = currentTotal + newFraction;
    }

    // Checagem de limite máximo (1.0)
    // Usamos uma pequena tolerância (1e-6) para lidar com imprecisões de ponto flutuante.
    // Checagem de limite máximo (1.0)
    if (fractionAfterAddition > 1.0 + 1e-6) { 
      final remainingCapacity = 1.0 - currentTotal;
      _showSnackBar(
        _getTranslation('erro_max_fracao_atingido')
        .replaceAll('{0}', remainingCapacity.clamp(0.0, 1.0).toStringAsFixed(3)), 
        Colors.red,
      );
      return;
    }

    setState(() {
      if (existingIndex != -1) {
        
        final currentItem = _selectedComponents[existingIndex];
        final updatedFraction = currentItem.fraction + newFraction;
        _selectedComponents[existingIndex] = currentItem.copyWith(fraction: updatedFraction);
        _selectedComponents[existingIndex] = currentItem.copyWith(fraction: newFraction);
      } else {
        // Novo componente: adiciona
        _selectedComponents.add(ComponentFraction(
          component: _selectedComponentToAdd, 
          fraction: newFraction,
        ));
      }

      // Limpa o campo de entrada e mostra o sucesso
      _fractionController.clear();
      _showSnackBar(_getTranslation('componente_adicionado'), Colors.green);
    });
  }

  void _removeComponent(ComponentFraction item) {
    setState(() {
      _selectedComponents.remove(item);
    });
    _showSnackBar(_getTranslation('componente_removido'), Colors.orange);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color(0xFF2F333A),
          title: Text(
      _getTranslation('titulo'),
      style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
      indicatorColor: Colors.amber,
      labelColor: Colors.amber,
      unselectedLabelColor: Colors.white70,
      tabs: [
        Tab(text: _getTranslation('aba_densidade')),
        Tab(text: _getTranslation('aba_massa')),
        Tab(text: _getTranslation('aba_propriedades')),
      ],
          ),
        ),
        body: TabBarView(
          children: [
      _buildDensidadeInput(),
      _buildMassaMolecularInput(),
      _buildTabelaPropriedades(),
          ],
        ),
      ),
    );
  }

  // --- Widgets de Abas ---

  Widget _buildDensidadeInput() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
      _getTranslation('aba_densidade'),
      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(_getTranslation('densidade_seco'), style: const TextStyle(color: Colors.white70)),
      leading: Radio<String>(
        value: 'Seca',
        groupValue: _selectedDensityType,
        onChanged: (String? value) {
          setState(() { _selectedDensityType = value!; });
        },
        activeColor: Colors.amber,
      ),
          ),
          ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(_getTranslation('densidade_umido'), style: const TextStyle(color: Colors.white70)),
      leading: Radio<String>(
        value: 'Úmida',
        groupValue: _selectedDensityType,
        onChanged: (String? value) {
          setState(() { _selectedDensityType = value!; });
        },
        activeColor: Colors.amber,
      ),
          ),
          const SizedBox(height: 32),
          TextField(
      controller: _densityController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: _getTranslation('label_densidade').replaceAll('{0}', _selectedDensityType),
        labelStyle: const TextStyle(color: Colors.amber),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54),),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber),),
      ),
          ),
          _buildConfirmButton(_onConfirmDensidade),
        ],
      ),
    );
  }

  Widget _buildMassaMolecularInput() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
      _getTranslation('aba_massa'),
      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
      controller: _massaMolecularController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: _getTranslation('label_massa_molecular'),
        labelStyle: const TextStyle(color: Colors.amber),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54),),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber),),
      ),
          ),
          _buildConfirmButton(_onConfirmMassaMolecular),
        ],
      ),
    );
  }

  Widget _buildTabelaPropriedades() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
      _getTranslation('aba_propriedades'),
      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // --- 1. Seção de Adição de Componente (MODIFICADA) ---
          Column( 
      crossAxisAlignment: CrossAxisAlignment.stretch, 
      children: [
        // 1. Seleção de Componente (Dropdown)
        DropdownButtonFormField<Component>(
          decoration: InputDecoration(
      labelText: _getTranslation('dropdown_selecione'),
      labelStyle: const TextStyle(color: Colors.amber),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          ),
          dropdownColor: const Color(0xFF2F333A),
          style: const TextStyle(color: Colors.white),
          value: _selectedComponentToAdd,
          items: Components.allComponents.map((Component component) {
      return DropdownMenuItem<Component>(
        value: component,
        child: Text(component.name),
      );
          }).toList(),
          onChanged: (Component? newValue) {
      if (newValue != null) {
        setState(() {
          _selectedComponentToAdd = newValue;
        });
      }
          },
        ),

        const SizedBox(height: 16), // Espaçamento entre os campos

        // 2. Fração Molar e Botão Adicionar (Agora com 50/50 de largura)
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
      Expanded(
        flex: 1, // Fração Molar ocupa 50%
        child: TextField(
          controller: _fractionController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
      labelText: _getTranslation('label_fracao'),
      labelStyle: const TextStyle(color: Colors.white54),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded( // Botão Adicionar ocupa 50%
        flex: 1,
        child: ElevatedButton(
          onPressed: _addComponentFraction,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            // Ajustando o padding vertical para casar melhor com o TextField
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(_getTranslation('botao_adicionar')),
        ),
      ),
          ],
        ),
      ],
          ),

          const SizedBox(height: 32),

          // --- 2. Tabela Dinâmica de Componentes ---
          _selectedComponents.isEmpty
        ? const Center(
      child: Text(
        'Nenhum componente adicionado.', 
        style: TextStyle(color: Colors.white54),
      )
          )
        : _buildComponentsTable(),

          _buildConfirmButton(_onConfirmPropriedades),
        ],
      ),
    );
  }

  Widget _buildComponentsTable() {
    final columns = [
      _getTranslation('cabecalho_componente'),
      _getTranslation('cabecalho_fracao'),
      _getTranslation('cabecalho_massa_molecular'),
      _getTranslation('cabecalho_pc'),
      _getTranslation('cabecalho_tc'),
      '', // Para o botão de remover
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2228),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white38),
      ),
      child: Column(
        children: [
          // Cabeçalho da Tabela
          Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: columns.map((title) => Expanded(
          flex: title == _getTranslation('cabecalho_componente') ? 3 : 2,
          child: Text(
      title,
      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
      textAlign: title == '' ? TextAlign.center : TextAlign.left,
          ),
        )).toList(),
      ),
          ),
          const Divider(color: Colors.white38, height: 1),

          // Linhas dos Componentes
          ..._selectedComponents.map((item) => _TableItemRow(
      item: item,
      onRemove: _removeComponent,
          )).toList(),

          const Divider(color: Colors.white38, height: 1),

          // Rodapé com Somatória Total
          Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
      flex: 3,
      child: Text(
        _getTranslation('total_somatoria'),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
          ),
          Expanded(
      flex: 2,
      child: Text(
        _totalFraction.toStringAsFixed(4), // Exibe a soma total
        style: TextStyle(
          // Alerta visual se a soma estiver acima de 1.0 (com tolerância)
          color: _totalFraction > 1.00001 ? Colors.red : Colors.greenAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
          const Expanded(flex: 2, child: SizedBox()),
          const Expanded(flex: 2, child: SizedBox()),
          const Expanded(flex: 2, child: SizedBox()),
        ],
      ),
          )
        ],
      ),
    );
  }
}

// Widget auxiliar para cada linha da tabela
class _TableItemRow extends StatelessWidget {
  final ComponentFraction item;
  final Function(ComponentFraction) onRemove;

  const _TableItemRow({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Row(
        children: [
          // Componente
          Expanded(
      flex: 3,
      child: Text(
        item.component.name.length > 15 
      ? '${item.component.name.substring(0, 12)}...' // Trunca nomes longos
      : item.component.name,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
          ),
          // Fração
          Expanded(
      flex: 2,
      child: Text(
        item.fraction.toStringAsFixed(4),
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
          ),
          // Massa Molecular
          Expanded(
      flex: 2,
      child: Text(
        item.component.molecularWeight.toStringAsFixed(3),
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
          ),
          // Pressão Pseudocrítica
          Expanded(
      flex: 2,
      child: Text(
        item.component.pseudocriticalPressure.toStringAsFixed(2),
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
          ),
          // Temperatura Pseudocrítica
          Expanded(
      flex: 2,
      child: Text(
        item.component.pseudocriticalTemperature.toStringAsFixed(2),
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
          ),
          // Botão de Remover
          Expanded(
      flex: 2,
      child: IconButton(
        icon: const Icon(Icons.remove_circle, color: Colors.red, size: 18),
        onPressed: () => onRemove(item),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
          ),
        ],
      ),
    );
  }
}